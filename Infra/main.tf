# main.tf

provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

# EC2 Instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-xxxxxxxxxxxxxxxxx" # Change this to your desired AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "EC2Instance"
  }
}

# ECR Repository
resource "aws_ecr_repository" "docker_repository" {
  name = "your-docker-repo"
}

# Kubernetes Deployment
resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name = "your-app-name"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "your-app-name"
      }
    }

    template {
      metadata {
        labels = {
          app = "your-app-name"
        }
      }

      spec {
        container {
          image = aws_ecr_repository.docker_repository.repository_url
          name  = "your-container-name"
        }
      }
    }
  }
}

# Kubernetes Service
resource "kubernetes_service" "app_service" {
  metadata {
    name = "your-app-name"
  }

  spec {
    selector = {
      app = "your-app-name"
    }

    port {
      port        = 80
      target_port = 8080 # Adjust this based on your application's port
    }

    type = "LoadBalancer" # Change this based on your networking requirements
  }
}
