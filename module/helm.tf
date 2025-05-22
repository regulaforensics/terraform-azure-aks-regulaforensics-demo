provider "kubernetes" {
  host                   = module.aks.host
  token                  = module.aks.password
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    token                  = module.aks.password
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

resource "helm_release" "faceapi" {
  count      = var.enable_faceapi == true ? 1 : 0
  name       = "faceapi"
  repository = "https://regulaforensics.github.io/helm-charts"
  chart      = "faceapi"

  values = [
    var.faceapi_values
  ]

}

resource "helm_release" "docreader" {
  count      = var.enable_docreader == true ? 1 : 0
  name       = "docreader"
  repository = "https://regulaforensics.github.io/helm-charts"
  chart      = "docreader"

  values = [
    var.docreader_values
  ]

}

resource "kubernetes_secret" "face_api_license" {
  count = var.enable_faceapi == true ? 1 : 0
  metadata {
    name = "faceapi-license"
  }
  type = "Opaque"
  binary_data = {
    "regula.license" = var.face_api_license
  }
}

resource "kubernetes_secret" "docreader_license" {
  count = var.enable_docreader == true ? 1 : 0
  metadata {
    name = "docreader-license"
  }
  type = "Opaque"
  binary_data = {
    "regula.license" = var.docreader_license
  }
}
