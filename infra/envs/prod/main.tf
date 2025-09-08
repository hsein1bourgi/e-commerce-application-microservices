module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    

    name = "${var.name}--vpc"
    cidr = "10.0.0.0/20"

    azs = var.azs
    
    # For  ALB and NAT gateways
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnets  = ["10.0.8.0/24", "10.0.9.0/24"]

    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = false

  tags = {
    Environment = "prod"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.name}-eks-cluster"
  kubernetes_version = "1.33"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
#   control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }

  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}




# ECR for container registry
resource "aws_ecr_repository" "customer" {
    name = "${var.name}-customer"
}
resource "aws_ecr_repository" "products" {
    name = "${var.name}-products"
}
resource "aws_ecr_repository" "shopping" {
    name = "${var.name}-shopping"
}

# # IAM OIDC for github actions

module "github_oidc" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role"

  name = "${var.name}-github-actions-role"

  enable_github_oidc = true

  # Allow GitHub repo(s) to assume this role
  oidc_wildcard_subjects = [
    "hsein1bourgi/e-commerce-application-microservices:*"
  ]

  policies = {
    EKSClusterPolicy   = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    EKSWorkerNodePolicy = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    ECRFullAccess      = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  }

  tags = {
    Environment = "prod"
  }
}


## HELM Addons will be here (argoCD, ingress, prometheus, grafana)

#ArgoCD
resource "helm_release" "argocd" {
    name       = "argocd"
    repository = "https://argoproj.github.io/argo-helm"
    chart      = "argo-cd"
    namespace  = "argocd"

    create_namespace = true

    values = [file("${path.module}/../values/argocd-values.yaml")]

    depends_on = [module.eks]
}

# Ingress-NGINX
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.2"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [file("${path.module}/../values/ingress-nginx-values.yaml")]

  depends_on = [module.eks]
}

# Prometheus + Grafana (via kube-prometheus-stack)
resource "helm_release" "kube_prometheus" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "58.1.0"
  namespace        = "monitoring"
  create_namespace = true

  values = [file("${path.module}/../values/kube-prometheus-stack-values.yaml")]

  depends_on = [module.eks]
}



