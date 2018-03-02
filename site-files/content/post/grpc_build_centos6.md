+++
title = "Building GRPC on CentOS 6"
date = 2018-03-02T11:04:27-05:00
description = "Building GRPC for CentOS Linux V.6"
draft = false
categories = ["Blog"]
tags = [ "grpc", "Linux" ]
images = []
+++

When transitioning from a monolithic application towards a more service oriented
architecture you're likely to either have a period where you have a hybrid setup
until all services are split out of the monolith or make the conscious decision
to leave some things be either temporarily or for the long term. Does this mean
you should have to sacrifice consistency in your API? NO!

In my case, I was dealing with servers as part of a monolithic application
running on CentOS 6. We chose to use GRPC for our services but it requires a
newer compiler than provided in the normal CentOS repos. This post will outline
my solution to the problem and hopefully help others who find themselves in
similar positions.

# The Compiler

CentOS 6 was released about 7 years ago. July 10 2011 to be exact. That means
it's Ancient in technology years. These stable OSes are great for running things
that you don't plan on changing for a very, very long time but not so great for
developing software using the latest tools and libraries. Such is the case if
you want to use GRPC within your application to talk to some of your more modern
services. The main issue is that the compiler available in CentOS 6 isn't C++11
compatible. As a result, the compile flags will not be recognized and it will
fail to build. The first thing we need to do then is find a C++11 compatible
compiler for CentOS 6.

# The Repository

After much searching I came across [a
repository](https://people.centos.org/tru/devtools-2/) on
[people.centos.org](https://people.centos.org) owned by Tru Huynh, a developer
with the CentOS project since 2005 and member of their infrastructure team. This
repository contains the devtools-2 packages which, coincidentally, include a
version of gcc which is C++11 compatible. To install this repository and the
compiler run the following:

```
wget http://people.centos.org/tru/devtools-2/devtools-2.repo -O /etc/yum.repos.d/devtools-2.repo
yum install devtoolset-2-gcc devtoolset-2-binutils devtoolset-2-gcc-c++
```

# Using the New Compiler

Once you've installed the packages above you'll need to be sure you're in the
right environment. There are two ways to do this. The quick way to do it (if
you're just testing) is to run:

```
scl enable devtoolset-2 bash
```

This will drop you in to a shell with the right environment to use the new
compiler. If you're doing this as part of a script or in a build server where
you'll always want to use this compiler, set the following in your environment
(either through .bash_profile, .bashrc, or similar):

```
echo "WARNING: devtoolset-2 is enabled!"
source /opt/rh/devtoolset-2/enable
```

That's it! You can now build GRPC (or wahtever you want) using this compiler and
it will work on CentOS 6.

# Conclusion and Notes

One thing to note about this repository. It is not an official repo and the
packages within it are not signed. The SRPMS are published if you want to look
over the work yourself or make any modifications. I'd suggestion you review
these tools careful before you decide to use them yourself.
