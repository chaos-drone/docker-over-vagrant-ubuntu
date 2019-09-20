# docker-over-vagrant-ubuntu
Vagrant file and a setup script for docker ready virtual machine with ubuntu.

## The setup
Ubuntu 18.04 generic  
Docker  
>enabled as a service  
>managable with non root user  

Docker Compose  
Autocomplete for docker

## Requirements
* Vagrant 2.2
* VM Provider (e.g. VirtualBox)

Tested with VirtualBox 6.0 on Windows

## Installation

```
$ git clone git@github.com:chaos-drone/docker-over-vagrant-ubuntu.git
$ cd docker-over-vagrant-ubuntu
$ vagrant up
```

## Usage
You get generic ubuntu with Docker. Further configuration and setup is to be done manually for now.

Private network IP is `10.20.1.2` by default.
