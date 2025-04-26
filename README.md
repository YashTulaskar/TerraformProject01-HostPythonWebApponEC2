Flask Web Application on AWS using Terraform

This project demonstrates how to deploy a simple Flask web application on AWS EC2 using Terraform for Infrastructure as Code. The infrastructure is fully automated, including the creation of necessary resources like VPC, subnet, security group, and EC2 instance.

Key Features:
Infrastructure Automation: Provision AWS resources (VPC, EC2, Subnet, etc.) using Terraform.

Web Application: A simple Flask app served on an EC2 instance.

Security: Configures security groups for HTTP and SSH access.

Background Execution: Flask app runs in the background using nohup for long-term availability.

Architecture Overview:
AWS VPC with a public subnet.

EC2 instance running Flask app accessible over HTTP (port 80).

Security Group to allow HTTP (80) and SSH (22) access.

Technologies:
Terraform: Infrastructure as Code for provisioning resources.

AWS EC2: Hosting the Flask app.

Python Flask: Web framework for the app.

Amazon Linux 2: EC2 instance OS.

Steps:
Terraform Setup: Ensure you have Terraform installed and AWS credentials configured.

Run Terraform: Execute terraform apply to provision resources.

Access the Application: Visit the public IP of the EC2 instance to view the Flask app.

How to Run:

# Clone the repository
git clone https://github.com/yourusername/your-repo.git

# Navigate to the project directory
cd your-repo

# Initialize Terraform
terraform init

# Apply Terraform configuration
terraform apply
Enjoy the app running on AWS with Terraform! 🚀
