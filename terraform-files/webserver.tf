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

resource "digitalocean_droplet" "www_xy0_org" {
    image              = "coreos-stable"
    name               = "www.xy0.org"
    region             = "sfo2"
    size               = "s-1vcpu-1gb"
    private_networking = true
    ssh_keys           = [
                            "eb:c3:a9:58:8f:1d:ab:5e:f0:61:43:af:5f:6e:a9:91",
                            "79:94:64:68:b0:ef:ab:07:40:dc:d6:73:e1:08:70:9b"
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
