# Docker Setup for CKAN Core

## Prerequisites

* [WSL2](https://docs.microsoft.com/en-us/windows/wsl/install) ***if using Windows***
* [Docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/)
* [Git](https://github.com/git-guides/install-git)
   * You will also need your git configuration to be accessible to your user, located by default at `~/.gitconfig`. This will be attached to the Docker container so that the build scripts can pull the repositories.
   * If using WSL2, you will need to have this config set up inside of WSL2 for your WSL2 user.

## Pre-Build

1. __Make__ `mkdir nginx postgres redis solr ckan`
1. __Copy__ `cp .env_example .env`
1. __Change__ `USER_ID` in .env to your local uid
1. __Change__ `GROUP_ID` in .env to your local gid
1. __Copy__ `cp registry_example.ini registry.ini`
1. __Change__ `ckanext.cloudstorage.container_name` in registry.ini value to `<your user name>-dev`
1. __Change__ `ckanext.cloudstorage.driver_options` in registry.ini secret value to the secret key for `opencanadastaging`

## Build

1. __Build__ the container: `docker-compose build`
   * ***The initial build will take a long time.***
   * If you are rebuilding and receive errors such as `max depth exceeded`, you may need to destroy all of the docker images (`docker image prune -a`) and then run the above build command. Please note that this will also destroy any other docker images you have on your machine.
   * If your build fails with errors regarding failure of resolving domains, restart your docker service (`sudo service docker restart`).
1. __Bring up__ the app and detach the shell: `docker-compose up -d` to make sure that all the containers can start correctly.
   * ***The initial up may take a long time.***
   * To stop all the containers: `docker-compose down`

## Installation

### Databases

1. __Bring up__ the CKAN Registry docker container: `docker-compose up -d ckan`
1. __Run__ the install script in the docker container: `docker-compose exec ckan ./fix-databases.sh`

### CKAN

1. __Bring up__ the CKAN Registry docker container: `docker-compose up -d ckan`
1. __Run__ the install script in the docker container: `docker-compose exec ckan ./install-ckan.sh`

## Usage

### CKAN

1. __Bring up__ the CKAN Registry docker container: `docker-compose up -d ckan`
1. __Open__ a browser into: `http://localhost:5001`
   1. Login here: `http://localhost:5001/en/user/login`
      1. Normal User:
         1. Username: `user_local`
         1. Password: `12345678`
      1. Sys Admin User:
         1. Username: `admin_local`
         1. Password: `12345678`
