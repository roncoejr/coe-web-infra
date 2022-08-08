terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean",
            version = "~> 2.0"
        }

        aws = {
            source = "hashicorp/aws",
            version = "~> 4.0"
        }
    }
}

variable do_token {}

variable aws_token {}

provider aws {
    token = var.aws_token
}

provider digitalocean {
    token = var.do_token

}

variable "dropletCount" {
    type = string
    default = 1
}

variable "dropletImage" {
    type = string
    default = "114385562"
}

variable "infraLocation" {
    type = string
    default = "nyc3"
}

data "digitalocean_ssh_key" "mykey" {
    name = "MB-ProRCJ"
}

data "digitalocean_account" "do_account" {

}

output  "droplet_limit" {
    value = data.digitalocean_account.do_account.droplet_limit
}

data "digitalocean_images" "do_images" {
    filter {
        key = "distribution"
        values = ["Ubuntu"]
    }
    filter {
        key = "regions"
        values = ["nyc1"]
    }

}

/*output "available_images" {
    value = data.digitalocean_images.do_images
}*/

resource "digitalocean_droplet" "web" {
  count = var.dropletCount
  image  = var.dropletImage
  name   = "${format("web-%004s", count.index + 1)}"
  region = var.infraLocation
  size   = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.mykey.id]
}