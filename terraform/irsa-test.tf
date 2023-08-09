# test_irsa_iam_assumable_role 
module "test_irsa_iam_assumable_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role  = true 
  role_name    = "TestIrsaS3ReadOnlyRole"
  provider_url = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns = [
    data.aws_iam_policy.s3_read_only_access_policy.arn # <------- AWS Managed IAM policyのARN
  ]
  oidc_fully_qualified_subjects = ["system:serviceaccount:default:test-irsa"] 
}

# iam policy data
data "aws_iam_policy" "s3_read_only_access_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" # <--- AWS Managed IAM policyのARN
}

## Kubernetes ##

# resource "kubernetes_service_account" "test-irsa-serviceaccount" {
#   metadata {
#     name      = "test-irsa"
#     namespace = "default"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = module.test_irsa_iam_assumable_role.iam_role_arn
#     }
#   }
# }