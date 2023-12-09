# main.tf

provider "aws" {
  region = "us-west-2" # Change this to your desired region
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-xxxxxxxxxxxxxxxxx" # Change this to your desired AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "EC2Instance"
  }
}

# Jenkins pipeline script
resource "null_resource" "jenkins_pipeline" {
  triggers = {
    instance_id = aws_instance.ec2_instance.id
  }

  provisioner "local-exec" {
    command = <<-EOT
      # Implement your Jenkins pipeline script here
      # You can use a template file or inline script
    EOT
  }
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
          image = "your-docker-image" # Replace with your Docker image URL
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

# Helm Chart
resource "helm_release" "your_helm_chart" {
  name       = "your-helm-release-name"
  repository = "https://charts.example.com" # Replace with your Helm repository URL
  chart      = "your-helm-chart-name"
  version    = "1.0.0" # Replace with the desired version

  values = [
    # Add your Helm values here
  ]

  depends_on = [
    kubernetes_service.app_service
  ]
}
