/* ECS Service Cluster */
resource "aws_ecs_cluster" "default" {
  name = "${var.ecs_cluster_name}"
}
