# =====================================
# Variable to control Kubernetes in CI
# =====================================
variable "enable_k8s" {
  default = true
}

# =====================================
# MongoDB Deployment
# =====================================
resource "kubernetes_deployment_v1" "mongodb" {
  count = var.enable_k8s ? 1 : 0

  metadata {
    name = "mongodb-deployment"
    labels = {
      app = "mongodb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }

      spec {
        container {
          name  = "mongodb"
          image = "mongo:latest"

          port {
            container_port = 27017
          }
        }
      }
    }
  }
}

# =====================================
# MongoDB Service
# =====================================
resource "kubernetes_service_v1" "mongodb_service" {
  count = var.enable_k8s ? 1 : 0

  metadata {
    name = "mongodb-service"
  }

  spec {
    selector = {
      app = "mongodb"
    }

    port {
      port        = 27017
      target_port = 27017
    }

    type = "NodePort"
  }
}