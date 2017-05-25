+++
categories = ["blog", "meta"]
date = "2017-05-23T23:09:14-04:00"
description = "Automating the Site with Hugo and Terraform"
draft = true
images = []
tags = ["blog", "meta"]
title = "Automating the Site with Hugo and Terraform"
toc = false

+++

# Introduction

Let's get a few facts out of the way before we dive in. This site is hosted on
[Digital Ocean](digitalocean.com). This site is built using
[Hugo](https://gohugo.io/).  I deploy this site using
[Terraform](https://www.terraform.io/). It runs on the lowest end $5/month
droplet from Digital Ocean.

If This sounds appealing to you, read further. We'll be discussing how you too
can have a blog site without the need for heavy CMS software like Wordpress,
etc.

# Summary

In this post we'll work through the process of running a simple blogging site
using Hugo. We will also discuss one possible way (the way I am using) to
deploy the site using Terraform via the Digital Ocean provider.

All code for this website can be found on the project page located on
[Github](https://github.com/k4k/xy0_org).

# Terraform

Terraform is an automated server deployment utility. You define how to construct
your server inside of a configuration file (or multiple configuration files in
the same directory). It has
[providers](https://www.terraform.io/docs/providers/) for many different cloud
service providers. For the purposes of this blog post I'll be focusing on the
provider for [Digital
Ocean](https://www.terraform.io/docs/providers/do/index.html).

## Installing Terraform

[Installing Terraform](https://www.terraform.io/intro/getting-started/install.html)
is fairly straight forward. On most platforms it's a matter of downloading the
platform specific zip/tar file and extracting the binary. This binary can then
be placed anywhere you like. I recommend with $HOME/bin or /usr/loca/bin for
convenience and consistency.

## Terraform Files

Defining your system is done in files with a .tf extension. For this site, I
have split the files up in to two different .tf files. The first file,
webserver.tf, is where the bulk of the configuration occurs. I have two main
sections within this file. The first section describes the DNS resource. This
uses the Digital Ocean provider to dynamically create a DNS A record for the
site once everything is setup and ready to go. The second section defines the
actual droplet. What image to use, droplet size, how to remotely connect and
what to do to configure the server.

The second file, provider.tf, contains the provider specific information. This
includes Digital Ocean API keys, private and public key file names and other
various information which I would not want made public to the world. I am a
firm believer in version controlling everything possible. By splitting up the
sensitive information I am able to put the bulk of the config on GitHub and add
an entry in to the .gitignore file for the provider.tf, avoiding any
possibility of accidentally uploading sensitive information to a public
repository.

You can find the Terraform file that deploys this website can be found
[here](#).

# Hugo

Hugo is a static website generator written in [Go](https://golang.org/), a powerful
and modern programming language. With Hugo, all of the page content is written
in [Markdown](https://daringfireball.net/projects/markdown). The layout of the
page is defined by it's [type](https://gohugo.io/content/types/). The
configuration files can be defined in TOML, YAML or JSON.

## Installing Hugo

[Installing Hugo](https://gohugo.io/overview/installing/) is slightly more complicated
than Terraform, but still fairly simple. If you are on MacOS I recommend
installing with [Homebrew](https://brew.sh/). All other platforms should
install using the platform specific instructions provided on the install page.

# Conclusion

While I've used other deployment and configuration utilities in the past. This
is my first experience with Terraform. Overall, my impressions are positive.
It's a good, general purpose, cloud deployment tool which makes getting started
down the path of [infrastructure as
code](https://en.wikipedia.org/wiki/Infrastructure_as_Code) easy and relatively
painless.

As you continue to expand upon the topics discussed here and run your site
long term, you will likely find that configuring specific aspects of your
server is tedious with Terraform. Shell scripts can only get you so far. I
would point anyone interested in learning more towards some of the industry
standard configuration management tools available today for free.
[Ansible](https://www.ansible.com/) and [SaltStack](https://www.ansible.com/)
are simple, popular options that are well suited for both small and large scale
use. If you find yourself needing more than either of those can provide,
[Puppet](https://puppet.com/) is a good option.  You can also use Puppet for
smaller scale deployments but some features are restricted without a complete
puppet master/client setup.
