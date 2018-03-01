variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "code_dir" {}

provider "digitalocean" {
    token = "${var.do_token}"
}
