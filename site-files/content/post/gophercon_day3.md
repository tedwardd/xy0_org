+++
categories = ["Blog"]
date = "2017-07-16T08:28:05-06:00"
description = ""
draft = false
images = []
tags = ["GopherCon", "Go", "Kubicorn"]]
title = "Gophercon Day 3"
toc = false

+++

Yes, you're not lost. I skipped day 2. Not physically but for the purposes of
this blog I'll be skipping it. Why you ask? It's simple, I am a day late
updating this thing and nothing memorable must have happened because I don't
remember anything specific about the day. The talks were good; I was able to
make it in to the ones I wanted this time. I won a plushie Gopher doll at the
Google booth.  But otherwise, uneventful.

Day three, however, was community day, and my experience was extremely positive
and memorable. Community day for me turned in to a Go hack-a-thon. I met up
with [Kris Nova](https://twitter.com/Kris__Nova) and others to work on Kris'
new project [Kubicorn](https://github.com/kris-nova/kubicorn).

Kubicorn is a project that helps a user manage cloud infrastructure for
Kubernetes.  With kubicorn a user can create new clusters, modify and scale
them, and take a snapshot of their cluster at any time. In other words, it's a
simplified re-thinking of how we define, deploy and backup our Kubernetes
cluster infrastructure. Rather than using JSON first, we define profiles as
struct literals and marshal in to an object. Striving for clean code and an
empathetic user experience.

This was my first experience working on a real project with Go. Getting in on a
project at such an early stage was a unique experience I was not well prepared
for. I am still very new to Go and have only a little experience contributing
actual code to a software project. Being able to work with other developers in
person as a neophyte was a huge boost. Normally I would not have had the
confidence to contribute to anything as technical as this project but having
other experienced developers nearby to assist with technical and design
questions allowed me to produce several pull requests against the project, as
minor as those PRs may have been.

As Gophercon comes to a close, I want to give a huge thank you to the
conference organizers. This conference was the best one I've attended this
year. It's still growing and with that comes some struggles and the GopherCon
team did a very good job of making the conference an experience to remember. I
will definitely look forward to being able to attend the conference again in the
future. Unfortunately, not next year (the dates conflict with another recurring
conference I have attended for over 10 years) but perhaps in 2019.
