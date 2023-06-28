resource "aws_vpc_peering_connection" "hub-spoke1-peering" {
  vpc_id        = aws_vpc.hub_vpc.id
  peer_vpc_id   = aws_vpc.spoke1_vpc.id
  auto_accept   = true


}

resource "aws_vpc_peering_connection" "hub-spoke2-peering" {
  vpc_id        = aws_vpc.hub_vpc.id
  peer_vpc_id   = aws_vpc.spoke2_vpc.id
  auto_accept   = true
}

#Create routes for VPC peering
#Route from hub to spokes

resource "aws_route_table" "route_to_spoke" {
  vpc_id = aws_vpc.hub_vpc.id

  route {
    cidr_block = "10.1.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.hub-spoke1-peering.id


  }
route {
    cidr_block = "10.2.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.hub-spoke2-peering.id
}

route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hub_igw.id
  }

}
resource "aws_route_table_association" "hub_route_table_to_subnet" {
  subnet_id      = aws_subnet.hub_subnet.id
  route_table_id = aws_route_table.route_to_spoke.id
}

resource "aws_main_route_table_association" "hub_main_route_table_association" {
  vpc_id         = aws_vpc.hub_vpc.id
  route_table_id = aws_route_table.route_to_spoke.id
}

#Route from spoke1 to hub

resource "aws_route_table" "route_spoke1_to_hub" {
  vpc_id = aws_vpc.spoke1_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.hub-spoke1-peering.id

  }
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spoke1_igw.id
  }


}

resource "aws_route_table_association" "spoke1_route_table_to_subnet" {
  subnet_id      = aws_subnet.spoke1_subnet.id
  route_table_id = aws_route_table.route_spoke1_to_hub.id
}

resource "aws_main_route_table_association" "spoke1_main_route_table_association" {
  vpc_id         = aws_vpc.spoke1_vpc.id
  route_table_id = aws_route_table.route_spoke1_to_hub.id
}

#Route from spoke2 to hub

resource "aws_route_table" "route_spoke2_to_hub" {
  vpc_id = aws_vpc.spoke2_vpc.id

  route {
    cidr_block = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.hub-spoke2-peering.id


  }
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spoke2_igw.id
  }

}

resource "aws_route_table_association" "spoke2_route_table_to_subnet" {
  subnet_id      = aws_subnet.spoke2_subnet.id
  route_table_id = aws_route_table.route_spoke2_to_hub.id
}

resource "aws_main_route_table_association" "spoke2_main_route_table_association" {
  vpc_id         = aws_vpc.spoke2_vpc.id
  route_table_id = aws_route_table.route_spoke2_to_hub.id
}


                