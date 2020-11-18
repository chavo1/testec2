provider "aws" {
  region = "ap-northeast-2"
  #region = "us-west-2"
}

provider "aws" {
  alias  = "london"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "canada"
  region = "ca-central-1"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "ubuntu_london" {
  provider = aws.london

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



variable "instance_type" {
  type = string
  default = "t3.micro"
  #default = "m5.24xlarge"
}


resource "aws_instance" "seoul" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  tags = {
    Name = "seoul"
  }
}

resource "aws_instance" "london" {
  provider = aws.london

  ami           = data.aws_ami.ubuntu_london.id
  instance_type = var.instance_type

  tags = {
    Name = "london"
  }
}
