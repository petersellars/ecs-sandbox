/* ECS Private Subnet */
resource "aws_subnet" "ecs_private" {
  vpc_id            = "${aws_vpc.ecs.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  count             = "${length(var.private_subnets)}"
 
  tags {
    Name = "${var.ecs_cluster_name}-subnet-private-${element(split(",", var.availability_zones), count.index)}"
  }

  depends_on = ["aws_vpc.ecs"]
}

/* ECS Public Subnet */
resource "aws_subnet" "ecs_public" {
  vpc_id                  = "${aws_vpc.ecs.id}"
  cidr_block              = "${var.public_subnets[count.index]}"
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  map_public_ip_on_launch = true
  count                   = "${length(var.public_subnets)}"

  tags {
    Name = "${var.ecs_cluster_name}-subnet-public-${element(split(",", var.availability_zones), count.index)}"
  }
  
  depends_on = ["aws_vpc.ecs"]
}

output "private_subnets" {
  value = ["${aws_subnet.ecs_private.*.id}"]
}

output "public_subnets" {
  value = ["${aws_subnet.ecs_public.*.id}"]
}

/* Public Internet Gateway and Routing */
resource "aws_internet_gateway" "ecs" {
  vpc_id = "${aws_vpc.ecs.id}"
  
  tags {
    Name = "${var.ecs_cluster_name}-igw"
  }
}

resource "aws_route_table" "ecs_public" {
  vpc_id = "${aws_vpc.ecs.id}"
  propagating_vgws = []

  tags {
    Name = "${var.ecs_cluster_name}-rt-public"
  }
}

resource "aws_route" "ecs_public_internet_gateway" {
  route_table_id         = "${aws_route_table.ecs_public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ecs.id}"
}

resource "aws_route_table_association" "ecs_public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.ecs_public.*.id, count.index)}"
  route_table_id = "${aws_route_table.ecs_public.id}"
}

output "public_route_table_ids" {
  value = ["${aws_route_table.ecs_public.*.id}"]
}

/* Private NAT Gateway and Routing */

/* NAT Gateway Elastic IP */
resource "aws_eip" "ecs_nateip" {
  vpc   = true
  count = "${length(var.private_subnets) * lookup(map("true", 1), "true", 0)}"
}

resource "aws_nat_gateway" "ecs_natgw" {
  allocation_id = "${element(aws_eip.ecs_nateip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.ecs_public.*.id, count.index)}"
  count         = "${length(var.private_subnets) * lookup(map("true",1), "true", 0)}"

  depends_on = ["aws_internet_gateway.ecs"]
}

resource "aws_route_table" "ecs_private" {
  vpc_id           = "${aws_vpc.ecs.id}"
  propagating_vgws = []
  count            = "${length(var.private_subnets)}"

  tags {
    Name = "${var.ecs_cluster_name}-rt-private=${element(split(",", var.availability_zones), count.index)}"
  }
}

resource "aws_route" "ecs_private_nat_gateway" {
  route_table_id         = "${element(aws_route_table.ecs_private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.ecs_natgw.*.id, count.index)}"
  count                  = "${length(var.private_subnets) * lookup(map("true", 1), "true", 0)}"
}

resource "aws_route_table_association" "ecs_private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.ecs_private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.ecs_private.*.id, count.index)}"
}

output "nat_eips" {
  value = ["${aws_eip.ecs_nateip.*.id}"]
}

output "private_route_table_ids" {
  value = ["${aws_route_table.ecs_private.*.id}"]
}
