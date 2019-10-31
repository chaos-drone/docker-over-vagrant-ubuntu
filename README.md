# docker-over-vagrant-ubuntu
Vagrant file and a setup script for docker ready virtual machine with ubuntu.

The goal of the project when ready is to allow to setup a running dockerized project just by adding few lines of configuration and executing `vagrant up`.

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

# Create settings.yml file if you want to change some of the settings e.g. synced folders
# cp settings.yaml.example settings.yaml

$ vagrant up
```

## Usage

Use `settings.yaml` for quick and straightforward configuration. Copy the file from `settings.yaml.example`. Only the settings availble in the example file are configurable in this file.

`$ cp settings/settings.yaml.example settings/settings.yaml`

### Automatically build images and run containers

If a `Dockerfile` is present in some of the synced forlders an image will be build and container will be started for this file. The tag of the image and the name of the container will be set to the mounth path. The mount path will be bind mounted to the container. The setup is looking for Dockerfile only on first level of the path.

E.g. 

```
synced_folders:
  - ["/host/path", "/mount/path"]
```

If there is a `Dockerfile` in the `/host/path` directory on the host machine then  an image will be build automatically and tagged with `mount-path`. After that container will be started with the same name. `/mount/path` will be bind mounted in the container with the same path.

This is the default behaviour of the setup and here are examples of how to change this behavirour:

* Disable all automatic actions

```
synced_folders:
  - ["/host/path", "/mount/path", docker: false]
```


* Use custom image name and container name

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      imageName: 'custom-name'
  }]
```

* Disable bind mount the synced folder in the container

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      bindMountSyncedFolder: [false]
  }]
```

* Bind mount synced folder to a different path

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      bindMountSyncedFolder: [true, '/opt/project']
  }]
```

* Bind mount path is also available as an environment variable in the running container

```
$ docker container exec <container-name> env
...
BIND_MOUNT_PATH=/opt/project
BIND_MOUNT_PATH_VAR_NAME=BIND_MOUNT_PATH
...
```

The variable name can be changed because the containerized app should not be coupled to this tool.

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      bindMountSyncedFolder: [true, ~, 'MY_PROJECT_PATH']
  }]
```

> Note the second element is '~', meaning the path remains unchanged.

This will result in:
```
$ docker container exec <container-name> env
...
BIND_MOUNT_PATH=/opt/project
BIND_MOUNT_PATH_VAR_NAME=MY_PROJECT_PATH
MY_PROJECT_PATH=/opt/project
...
```

* Disable the automatic image building

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      build: [false]
  }]
```

* Add arguments for image building

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      build: [true, '-a', '--arg=1', '--arg=2']
  }]
```

* Disable running the container automatically

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      run: [false]
  }]
```

* Add arguments for running the container

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      run: [true, '-a', '--arg=1', '--arg=2']
  }]
```

### Set environment variables for the container

```
synced_folders:
  - ["/host/path", "/mount/path", docker: {
      env: { FOO: 'bar' }
  }]
```

The variable will be passed as an argument to the docker run command as `--env "FOO=bar"`

```
$ docker container exec <container-name> env
...
FOO=bar
...
```

You can also create `UserConfigure` class in which you can levarage the full power of vagrant configuration and access the settings values. Automaic image building and container running is not available for synced folders cnfigured in this class. Copy the example file `UserConfigure.rb.example`

`$ cp settings/UserConfigure.rb.example settings/UserConfigure.rb`

Private network IP is `10.20.1.2` by default.
