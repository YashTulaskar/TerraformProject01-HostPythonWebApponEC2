provider "aws" {
    region = "us-east-1" 
}

variable "cidr" {
    default = "10.0.0.0/16"
}

resource "aws_key_pair" "mykey01" {
    key_name = "yash-ssh-key"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "myvpc-01" {
    cidr_block = var.cidr
}

resource "aws_subnet" "mysubnet-01" {
    vpc_id = aws_vpc.myvpc-01.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "my-igw-01" {
    vpc_id = aws_vpc.myvpc-01.id
}

resource "aws_route_table" "my-rt-01" {
    vpc_id = aws_vpc.myvpc-01.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my-igw-01.id
    }
}

resource "aws_route_table_association" "rta1" {
    route_table_id = aws_route_table.my-rt-01.id
    subnet_id = aws_subnet.mysubnet-01.id  
}

resource "aws_security_group" "mysg-01" {
    name = "web"
    vpc_id = aws_vpc.myvpc-01.id
    ingress {
        description = "http allowed"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "ssh allowed"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "all outbond allowed"
        from_port = 0 
        to_port = 0 
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "web sg"
    }  
}

resource "aws_instance" "myserver-01" {
    ami = "ami-0e449927258d45bc4"
    instance_type = "t2.micro"
    key_name = aws_key_pair.mykey01.id
    vpc_security_group_ids = [ aws_security_group.mysg-01.id ]
    subnet_id = aws_subnet.mysubnet-01.id
    
    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host = self.public_ip
    }

    provisioner "file" {
        source = "app.py"
        destination = "/home/ec2-user/app.py" 
    }
    provisioner "file" {
        source = "templates"
        destination = "/home/ec2-user/templates" 
    }

    provisioner "remote-exec" {
        inline = [ 
            "echo 'Hello from the remote instance'",
            "sudo yum update -y",
            "sudo yum install -y python3-pip",
            "cd /home/ec2-user",
            "sudo pip3 install flask",
            "nohup sudo python3 /home/ec2-user/app.py > /home/ec2-user/app.log 2>&1 &",
         ]
      
    }  
}