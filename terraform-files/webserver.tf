resource "digitalocean_floating_ip" "www_xy0_org" {
    droplet_id = "${digitalocean_droplet.www_xy0_org.id}"
    region     = "${digitalocean_droplet.www_xy0_org.region}"
}

resource "digitalocean_record" "www_xy0_org" {
    domain = "xy0.org"
    type   = "CNAME"
    name   = "www"
    value  = "xy0.org."
}

resource "digitalocean_record" "xy0_org" {
    domain = "xy0.org"
    type   = "A"
    name   = "@"
    value  = "${digitalocean_floating_ip.www_xy0_org.ip_address}"
}

resource "digitalocean_droplet" "www_xy0_org" {
    image              = "coreos-stable"
    name               = "www.xy0.org"
    region             = "sfo2"
    size               = "512mb"
    private_networking = true
    ssh_keys           = [
                            "${var.ssh_fingerprint}"
                         ]
    connection {
        user        = "core"
        type        = "ssh"
        private_key = "${file(var.pvt_key)}"
        timeout     = "2m"
        agent       = false
    }

    provisioner "remote-exec" {
        inline = [
            "sudo mkdir /web",
            "sudo chown -R core:core /web",
        ]
    }
        
    provisioner "file" {
        source      = "${var.code_dir}/public"
        destination = "/web"
    }

    provisioner "remote-exec" {
        inline = [
            "sudo chown -R root:root /web",
            "sudo find /web -type d -exec chmod 755 {} +",
            "sudo find /web -type f -exec chmod 444 {} +",
            "sudo docker run -d -v /web/public:/usr/share/nginx/html -p 80:80 nginx",
        ]
    }

}
