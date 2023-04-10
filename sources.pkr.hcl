packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "image" {
  ami_name = "${var.ami_name}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  #galaxy_file = "requirements.yml"
  spot_instance_types = ["t3a.small", "t3a.medium"]
  spot_price = 0.0854
  region        = "us-east-1"
  encrypt_boot = true
  ssh_username = var.ssh_username
  ssh_interface = "public_ip"

  vpc_filter {
    filters = {
      "tag:Packer" : "Yes"
    }
  }
  subnet_filter {
        random = true
        filters = {
            "tag:Packer": "Yes"
        }
    }
  security_group_filter {
        filters = {
            "tag:Packer": "Yes"
        }
  }
  source_ami_filter {
    owners      = ["aws-marketplace"]
    most_recent = true

    filters = {
      virtualization-type = "hvm"
      hypervisor          = "xen"
      architecture        = "x86_64"
      name                = "CIS Red Hat Enterprise Linux 7 Benchmark * - Level 1-*"
    }
  }
}
