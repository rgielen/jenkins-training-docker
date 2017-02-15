[![](https://images.microbadger.com/badges/image/rgielen/jenkins-training.svg)](https://microbadger.com/images/rgielen/jenkins-training "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/rgielen/jenkins-training.svg)](https://microbadger.com/images/rgielen/jenkins-training "Get your own version badge on microbadger.com")
# Jenkins Training Docker Container

A Jenkins container with auto-installed plugins.

Latest Jenkins container derived from [official Jenkins Docker Image](https://hub.docker.com/_/jenkins/) with automatic plugin installation and environment enhancements.
Mainly used for training purposes, but serves as well as a nicely configured starting point for other experiments.

## Features

The image contains a lot of plugins pre-installed.
It also contains docker binaries, such that docker images can be started "within" (sibling mode) the Jenkins container once the docker socket from host is mapped.

## Usage

### Ensure Docker is running

#### Using Docker Toolbox

When running with Docker Toolbox, open Docker Quickstart Terminal and wait until everything is set up.

You can also use `docker-machine start` in a terminal of your choice.
To continue in this terminal, don't forget to follow the instructions on screen - basically the same instructions you get when running `docker-machine env default`.
Be sure to execute the part found below `# Run this command to to configure your shell`.

#### Using Docker Native

Ensure docker daemon is started. 
Everything should be ready to go then. 

### Start Jenkins Container

Suggested commandline:
    
    docker run -p 10080:8080 --name jenkins -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock rgielen/jenkins-training

The options explained:
  * `docker run` is your base command. 
    If not available locally, the image will be pulled. 
    Then is will be started in attached mode.
  * `-p 10080:8080` maps the container port 8080 to 10080 on your host. 
    Chose a port different from 10080 if you like.
  * `--name jenkins` gives the container the name `jenkins`. 
    Chose any name you like or omit it if you like hashes of random naming ;)
  * `-v jenkins_home:/var/jenkins_home` creates and maps a docker data container named `jenkins_home` to the container mount point `/var/jenkins_home`.
    Alternatively you might want to mount a host directory instead.
    See [Manage data in containers](https://docs.docker.com/engine/tutorials/dockervolumes/) for details.
  * ` -v /var/run/docker.sock:/var/run/docker.sock` mounts the host's docker socket for usage within the container.
    This enables the docker client within the container to start docker containers on the host using `sudo`
    Be careful with this option, [since basically the container gains root access to your host](http://stackoverflow.com/questions/40844197/what-is-the-docker-security-risk-of-var-run-docker-sock).
  * `rgielen/jenkins-training` is the name of the image to run.

### Stop Jenkins Container

When following the commandline above, you will be running in attached mode.
The container is configured to shut down gracefully on `Ctrl-C`, so here you go.
`docker stop jenkins` will stop the container, given you named it jenkins, from any other shell or when running in detached mode.

### Using Jenkins Container

#### Browser Access On Docker Toolbox

Docker basically runs in a VirtualBox virtual machine on your physical machine.
To access the running container, you need to know the IP address of the virtual machine.
When you started your machine earlier, this machine address was echoed during startup.
To find this out later, use `docker-machine env default`.
The IP address you are looking for is the one echoed in the DOCKER_HOST line.

Usually the address will be 192.168.99.100.
Given this is the case, and given you chose port 10080 in the start command above, you can now open a browser window with the URL `http://192.168.99.100:10080`.

#### Browser Access On Docker Native

Given you chose port 10080 in the start command above, you can now open a browser window with the URL `http://localhost:10080`.

#### First time startup

You will be prompted for an initial setup password.
You find the password in the console output from your running Jenkins container.
Look for something similar to

    *************************************************************
    *************************************************************
    *************************************************************
    
    Jenkins initial setup is required. An admin user has been created and a password generated.
    Please use the following password to proceed to installation:
    
    94b0c926a101440388062e30ab3f2626
    
    This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
    
    *************************************************************
    *************************************************************
    *************************************************************

This is the password you are looking for.

Afterward, setup an admin user as desired.

Last you will be presented with a choice to install default or specific plugins.
Chose as you like.
Most plugins will be installed already, so the this step should end quickly.

#### Create Jobs

Go ahead and configure Jenkins as you like and create new Jobs.

### Updating the image

To receive the latest image, run `docker pull rgielen/jenkins-training` before next container start.

## Source code and Issues

The sources are found on [GitHub](https://github.com/rgielen/jenkins-training-docker).
Please also report issues there.
