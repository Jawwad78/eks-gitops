resource "aws_security_group" "public-sg" {
  name   = "public-sg"
  vpc_id = aws_vpc.eks.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

resource "aws_security_group_rule" "nlb-to-eks-egress" {
  type                     = "egress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.public-sg.id
  source_security_group_id = aws_security_group.private-sg.id
}

resource "aws_security_group" "private-sg" {
  name   = "private-sg"
  vpc_id = aws_vpc.eks.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "private-sg"
  }
}

resource "aws_security_group_rule" "eks-to-nlb-ingress" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private-sg.id
  source_security_group_id = aws_security_group.public-sg.id
}