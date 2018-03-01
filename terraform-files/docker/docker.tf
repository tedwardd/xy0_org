resource "digitalocean_droplet" "docker_xy0_org" {
    image              = "24976933"
    name               = "docker.xy0.org"
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

   # provisioner "remote-exec" {
   #     inline = [
   #     ]
   # }

   # provisioner "file" {
   #     source      = "${var.code_dir}/public"
   #     destination = "/usr/share/nginx/html"
   # }

}
