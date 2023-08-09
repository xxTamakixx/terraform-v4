resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  
  namespace  = "kube-system"
  set {
    name  = "autoDiscovery.clusterName"
    value = data.aws_eks_cluster.eks.name
  }

  set {
    name  = "awsRegion"
    value = "ap-northeast-1"
  }

  set {
    name  = "rbac.create"
    value = true
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "arn:aws:iam::119834080691:role/EKSClusterAutoscaler" 
  }
}