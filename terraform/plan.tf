variable "domain" {
  type = string
}

resource "digitalocean_ssh_key" "max" {
  name = "max key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "web" {
  name = "web1"
  image = "ubuntu-18-04-x64"
  region = "sfo2"
  size = "512mb"
  ssh_keys = [
    digitalocean_ssh_key.max.fingerprint,
  ]
}

resource "digitalocean_record" "www" {
  domain = var.domain
  type   = "A"
  name   = "www"
  value  = digitalocean_droplet.web.ipv4_address
}

output "instance_ip_addr" {
  value = digitalocean_droplet.web.ipv4_address
}