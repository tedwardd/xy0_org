terraform {
  backend "s3" {
    bucket = "xy0-bucket"
    key = "tfstate_files/terraform.tfstate"
    region = "us-east-1"
    endpoint = "https://nyc3.digitaloceanspaces.com"
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_requesting_account_id  = true
    skip_metadata_api_check = true
  }
}

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

resource "digitalocean_droplet" "www_xy0_org" {
    image              = "coreos-stable"
    name               = "www.xy0.org"
    region             = "sfo2"
    size               = "s-1vcpu-1gb"
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
