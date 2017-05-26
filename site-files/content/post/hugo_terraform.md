+++
categories = ["blog", "meta"]
date = "2017-05-23T23:09:14-04:00"
description = "Automating the Site with Hugo and Terraform"
draft = false
images = []
tags = ["blog", "meta"]
title = "Automating the Site with Hugo and Terraform"
toc = false

+++

# Introduction

I'd like to start with a some background. This site is hosted on [Digital
Ocean](digitalocean.com). This site is built using [Hugo](https://gohugo.io/).
I deploy this site using [Terraform](https://www.terraform.io/). It runs on the
lowest end $5/month droplet from Digital Ocean.

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

Terraform is an automated server deployment utility. You define how to
construct your server inside of a configuration file (or multiple configuration
files in the same directory). It has
[providers](https://www.terraform.io/docs/providers/) for many different cloud
service providers. For the purposes of this blog post I'll be focusing on the
provider for [Digital
Ocean](https://www.terraform.io/docs/providers/do/index.html).

## Installing Terraform

[Installing
Terraform](https://www.terraform.io/intro/getting-started/install.html) is
fairly straight forward. On most platforms it's a matter of downloading the
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
[here](https://github.com/k4k/xy0_org/blob/master/terraform-files/webserver.tf).

# Hugo

Hugo is a static website generator written in [Go](https://golang.org/), a
powerful and modern programming language. With Hugo, all of the page content is
written in [Markdown](https://daringfireball.net/projects/markdown). The layout
of the page is defined by it's [type](https://gohugo.io/content/types/). The
configuration files can be defined in TOML, YAML or JSON.

## Installing Hugo

[Installing Hugo](https://gohugo.io/overview/installing/) is slightly more
complicated than Terraform, but still fairly simple. If you are on MacOS I
recommend installing with [Homebrew](https://brew.sh/). All other platforms
should install using the platform specific instructions provided on the install
page.

## Build your first Hugo site

Once installed, creating the skeleton for your first site is as simple as
running `hugo new site <name_of_site>`. Change directories in to your site and
edit the config.toml file. You can find the config toml used for this site
[here](https://github.com/k4k/xy0_org/blob/master/site-files/config.toml). This
config file defines the value of things such as your site name and theme as
well as the [menu](https://gohugo.io/extras/menus/) for your site.

Once you have some of the config.toml figured out you should select a theme.
Right out of the box, your site doesn't know how to serve up the content files
we will be adding. Adding a basic theme from the [gohugo
themes](http://themes.gohugo.io/) site is a quick way to get your content up.
If you want to do so later on there is great
[documentation](https://gohugo.io/tutorials/creating-a-new-theme/) on making
your own themes. For this tutorial, we'll use the
[after-dark](http://themes.gohugo.io/theme/after-dark/) theme that I'm using here.

After extracting the contents of the downloaded theme file to the themes
directory, we can return to the project root and run `hugo new post/first.md`.
This will create a new post for us under content/post named "first.md". This
file is already populated with what is called "front matter". Front matter is
meta data about the page. It is defined using the archetypes found in the
"archetypes" folder. If you now, from the project root, run `hugo serve` you
will start a web server on your system and should be able to browse the site by
visiting http://localhost:1313.

But wait, there's no content! Open content/post/first.md in your favorite text
editor and edit the "draft = true" to say "draft = false" instead.
Altneratively you can run the `hugo serve` command with the -D flag to render
pages marked as drafts.

If the above worked, the page you now see tells you a little about configuring
archetypes for the after-dark theme. Follow the instructions and edit the post
archetype to remove that message but leave the front matter in place.

# Putting the Two Together

Putting these two together requires just a little bit of glue but it's more than
I care to explain in a blog post so I've made my entire setup [publicly available
on Github](https://github.com/k4k/xy0_org). Most of it is documented and the scripts
make getting things setup fairly simple. It should be sufficiently detailed to
start you down the road of deploying your hugo site using terraform, at least.

# Conclusion

While I've used other deployment and configuration utilities in the past. This
is my first experience with Terraform. Overall, my impressions are positive.
It's a good, general purpose, cloud deployment tool which makes getting started
down the path of [infrastructure as
code](https://en.wikipedia.org/wiki/Infrastructure_as_Code) easy and relatively
painless.

As you continue to expand upon the topics discussed here and run your site long
term, you will likely find that configuring specific aspects of your server is
tedious with Terraform. Shell scripts can only get you so far. I would point
anyone interested in learning more towards some of the industry standard
configuration management tools available today for free.
[Ansible](https://www.ansible.com/) and [SaltStack](https://www.ansible.com/)
are simple, popular options that are well suited for both small and large scale
use. If you find yourself needing more than either of those can provide,
[Puppet](https://puppet.com/) is another good option.  You can also use Puppet
for smaller scale deployments but some features are restricted without a
complete puppet master/client setup.
