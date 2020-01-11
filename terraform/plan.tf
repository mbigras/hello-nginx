variable "domain" {
  type = string
}

resource "digitalocean_ssh_key" "root" {
  name = "root key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "web1" {
  name = "web1"
  image = "ubuntu-18-04-x64"
  region = "sfo2"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    digitalocean_ssh_key.root.fingerprint,
  ]
}

resource "digitalocean_droplet" "web2" {
  name = "web2"
  image = "ubuntu-18-04-x64"
  region = "sfo2"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    digitalocean_ssh_key.root.fingerprint,
  ]
}

resource "digitalocean_droplet" "web3" {
  name = "web3"
  image = "ubuntu-18-04-x64"
  region = "sfo2"
  size = "512mb"
  private_networking = true
  ssh_keys = [
    digitalocean_ssh_key.root.fingerprint,
  ]
}

resource "digitalocean_record" "web1" {
  domain = var.domain
  type   = "A"
  name   = "web1"
  value  = digitalocean_droplet.web1.ipv4_address
}

resource "digitalocean_record" "web2" {
  domain = var.domain
  type   = "A"
  name   = "web2"
  value  = digitalocean_droplet.web2.ipv4_address
}

resource "digitalocean_record" "web3" {
  domain = var.domain
  type   = "A"
  name   = "web3"
  value  = digitalocean_droplet.web3.ipv4_address
}

resource "digitalocean_loadbalancer" "lb" {
  name   = "lb"
  region = "sfo2"

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 80
    protocol = "http"
    path = "/"
  }

  droplet_ids = [
    digitalocean_droplet.web1.id,
    digitalocean_droplet.web2.id,
    digitalocean_droplet.web3.id,
  ]
}

resource "digitalocean_record" "www" {
  domain = var.domain
  type   = "A"
  name   = "www"
  value  = digitalocean_loadbalancer.lb.ip
}
