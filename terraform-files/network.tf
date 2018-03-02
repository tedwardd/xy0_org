resource "digitalocean_floating_ip" "www_xy0_org" {
    droplet_id = "${digitalocean_droplet.www_xy0_org.id}"
    region     = "${digitalocean_droplet.www_xy0_org.region}"
}

resource "digitalocean_record" "www_xy0_org" {
    domain = "xy0.org"
    type   = "CNAME"
    name   = "www"
    value  = "xy0.org."
    ttl    = "60"
}

resource "digitalocean_record" "xy0_org" {
    domain = "xy0.org"
    type   = "A"
    name   = "@"
    value  = "${digitalocean_floating_ip.www_xy0_org.ip_address}"
    ttl    = "60"
}

resource "digitalocean_record" "platfrastructure_life" {
    domain = "platfrastructure.life"
    type   = "A"
    name   = "@"
    value  = "${digitalocean_floating_ip.www_xy0_org.ip_address}"
    ttl    = "60"
}

resource "digitalocean_record" "www_platfrastructure_life" {
    domain = "platfrastructure.life"
    type   = "CNAME"
    name   = "www"
    value  = "platfrastructure.life."
    ttl    = "60"
}
