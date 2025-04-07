# Cloud Native Photo Sharing App

## Overview

This project is a simple, cloud-native photo sharing application. Users can upload photos, which are then displayed in an image gallery. The application leverages various AWS services for scalability, reliability, and storage, all provisioned using Terraform.

## Architecture

The application utilizes the following AWS services:

* **Amazon S3:** Used for storing the uploaded photo files.
* **Amazon DynamoDB:** Stores metadata associated with each uploaded photo (e.g., filename, upload timestamp).
* **Amazon EC2 Auto Scaling Group:** Manages a group of EC2 instances running the application server, ensuring availability and scalability based on demand.
* **Application Load Balancer (ALB):** Distributes incoming traffic across the EC2 instances in the Auto Scaling group, providing a single point of access.
* **Terraform:** Infrastructure as Code (IaC) tool used to define and provision all the required AWS resources.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

1.  **AWS Account:** An active AWS account with appropriate permissions to create the resources mentioned above.
2.  **AWS CLI:** Configured with your AWS Access Key ID and Secret Access Key. You can configure it by running `aws configure`.
3.  **Terraform:** Install Terraform (version v1.11.1 or later recommended). [Download Terraform](https://www.terraform.io/downloads.html)
4.  **Git:** To clone the repository.

## Setup Instructions

Follow these steps to deploy the application:

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/StormyStack/photo-sharing-app.git
    cd photo-sharing-app
    ```

2.  **Navigate to Terraform Directory:**
    ```bash
    cd terraform
    ```

3.  **Create Terraform Variables File:**
    Create a file named `terraform.tfvars` in the `terraform` directory. You might need to define specific variables here if the Terraform configuration requires them (e.g., custom tags, specific naming prefixes). *Refer to the `.tf` files for required or optional variables.*

4.  **(Optional) Configure AWS Region:**
    If you want to deploy the application to a region other than the default specified in `provider.tf`, modify the `region` argument within the file.

5.  **Initialize Terraform:**
    This command initializes the Terraform working directory, downloading necessary providers.
    ```bash
    terraform init
    ```

6.  **Apply Terraform Configuration:**
    This command creates all the defined AWS resources. The `-auto-approve` flag skips the confirmation prompt.
    ```bash
    terraform apply -auto-approve
    ```

7.  **Get Load Balancer DNS:**
    After the apply command completes successfully, Terraform will output the DNS name of the Application Load Balancer. Look for an output similar to:
    ```
    Outputs:
    alb_dns_name = "[your-alb-dns-name.region.elb.amazonaws.com]
    ```
    Copy this DNS name.

## Usage

1.  Open your web browser.
2.  Paste the `alb_dns_name` obtained from the Terraform output into the address bar.
3.  Press Enter.
4.  You should now be able to access the photo sharing application, upload photos, and view them in the gallery.

## Cleanup

To avoid ongoing charges for the AWS resources, you can destroy the infrastructure when you are finished:

1.  Navigate to the `terraform` directory:
    ```bash
    cd terraform
    ```
2.  Run the destroy command:
    ```bash
    terraform destroy -auto-approve
    ```
    This will remove all the resources created by Terraform for this project.