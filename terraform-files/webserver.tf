resource "digitalocean_record" "www_xy0_org" {
    domain = "xy0.org"
    type   = "A"
    name   = "www"
    value  = "${digitalocean_droplet.www_xy0_org.ipv4_address}"
}

resource "digitalocean_droplet" "www_xy0_org" {
    image              = "centos-7-x64"
    name               = "www.xy0.org"
    region             = "sfo2"
    size               = "512mb"
    private_networking = true
    ssh_keys           = [
                            "${var.ssh_fingerprint}"
                         ]
    connection {
        user        = "root"
        type        = "ssh"
        private_key = "${file(var.pvt_key)}"
        timeout     = "2m"
        agent       = false
    }
        
    #provisioner "file" {
    #    source      = "files/scripts/bootstrap.sh"
    #    destination = "/tmp/bootstrap.sh"
    #}

    provisioner "remote-exec" {
        inline = [
            "export PATH=$PATH:/usr/bin",
            # Install epel
            "sudo yum install -y epel-release",
            # install nginx
            "sudo yum update -y && sudo yum upgrade -y",
            "sudo yum install -y nginx",
            "sudo systemctl start nginx",
            #"sudo chmod +x /tmp/boostrap.sh",
            #"sudo /tmp/boostrap.sh"
            "sudo rm -rf /usr/share/nginx/html"
        ]
    }

    provisioner "file" {
        source      = "${var.code_dir}/public"
        destination = "/usr/share/nginx/html"
    }

}
