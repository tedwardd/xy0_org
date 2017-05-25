# Source files for www.xy0.org

These are the source files for the website [www.xy0.org](www.xy0.org).

The directory is roughly organized into three sections. The scripts directory
contains scripts used for building, deploying and developing the site. The
site-files directory contains the Hugo source files. Finally the
terraform-files directory contains the terraform configuration files used for
deploying the site.

To get started, run `script/bootstrap` to install hugo, install terraform, and
configure the necessary environment variables (used for terraform). Once your
environment is ready to go, you can use `script/build` to build the site in
`site-files/public`.  Test the site locally with `script/run`. Finally you can
deploy the site using `script/deploy` and you can destroy the site using
`script/destroy`.
