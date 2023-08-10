# terraform-v4
EKS を terraform で下記の実装と共に作成します。

RBAC を利用した authentication, authorization。
Pod レベルの authorization と IRSA。
Cluster Autoscaler を helm で実装。
Taint, Node Affinity の実装。

Iam User の作成と、clusterrolebinding のデプロイは手動を想定しています。
