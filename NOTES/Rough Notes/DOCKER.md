Docker install-

`sudo pacman -S gnome-terminal`

`sudo pacman -S docker`

`sudo systemctl enable --now docker.service`

`sudo systemctl start --now docker.service`

`sudo usermod -a -G docker aayush(username)`

`su aayush` (_always have to use this else permission denied_ )

ON UBUNTU ->

```# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```


`sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin`


`docker info`

Images- Lightweight,standalone ,executable package (consist of code,runtime,libraries,system tools )(this like a recipe)

Container- Runnable instance of docker image execution environment (this like a baked cake) we can run multiple container using single image

Volumes- Persistent data storage mechanism that allow data to be share b/w docker container and host computer (server even with multiple container) (its like share folder exist outside of the container)

Networks- Different docker container to talk to each other or external world it create connectivity allowing container to share information and services while maintaining isolation(its like restaurant where multiple kitchens isolated and host or docker network allowing collaboration to take recipe from other chief or the containers)

Docker Client (ui to interacting with docker by cli or gui build ,run,pull or manage container)

Docker Host(docker daemon) -(background process responsible for managing container on host system it listen docker client commands build images and create container)

Docker Registry(Docker hub)- Centralized repo of docker images it host public and private registry or package (git - github / docker -dockerhub)

Docker images stored in this registry and we run container docker pull the required image from registry if its unavailable locally

_CMD as Default executable_ _ENTRYPOINT fixed starting point_ (if both provide Entrypoint will override CMD)

`docker image ls or docker images` - To list all images

`docker ps -a` - To list all containers running

`docker volume ls` - To list all volumes

`docker stop <container-id>/<imagename>` To stop the container we can use 3 digit id and if it return same means successful

`docker container prune` this will remove all stopped container

`docker rm <container-id> --force` to remove specific container and if it give error running container cant be remove then we can use force

**Remove Image ->**

**Docker volumes ->**

this will stop all the container and remove all container along with volumes

`docker stop $(docker ps -aq)`

`docker container rm -f $(docker container ls -aq)`

`docker volume rm -f $(docker volume ls -q)`

`Basic Dockerfile** ->`
```# set the base image to create the image for react app
FROM node:20-alpine

# create a user with permissions to run the app
# -S -> create a system user
# -G -> add the user to a group
# This is done to avoid running the app as root
# If the app is run as root, any vulnerability in the app can be exploited to gain access to the host system
# It's a good practice to run the app as a non-root user
RUN addgroup app && adduser -S -G app app

# set the user to run the app
USER app

# set the working directory to /app
WORKDIR /app

# copy package.json and package-lock.json to the working directory
# This is done before copying the rest of the files to take advantage of Docker’s cache
# If the package.json and package-lock.json files haven’t changed, Docker will use the cached dependencies
COPY package*.json ./

# sometimes the ownership of the files in the working directory is changed to root
# and thus the app can't access the files and throws an error -> EACCES: permission denied
# to avoid this, change the ownership of the files to the root user
USER root

# change the ownership of the /app directory to the app user
# chown -R <user>:<group> <directory>
# chown command changes the user and/or group ownership of for given file.
RUN chown -R app:app .

# change the user back to the app user
USER app

# install dependencies
RUN npm install

# copy the rest of the files to the working directory
COPY . .

# expose port 5173 to tell Docker that the container listens on the specified network ports at runtime
EXPOSE 5173

# command to run the app
CMD npm run dev
```
``

also expose only container port so to run mern stack app we need port mapping so host can listen to the container port

`docker run -p 5173(this is docker port):5173(this i host port) superman(docker image)`

_to expose vite port we can use vite --host on scripts dev_

To sync docker with local file changes

`docker run -p 5173:5173 -v "$(pwd):/app" -v /app/node_modules imagename`

v will add a volume for persistent data changes and make node_modules available in container **Publish Docker Image** ->

`docker login`

`docker tag hello-world aayushbahukhandi/superman` (hello-world is image name from local pc and superman the name you want to give)

`docker push aayushbahukhandi/superman`

**Docker compose ->**

`docker compose up` It uses to define manage multi docker container

`docker init` we initialize our app with all file needed of our tech stack

_issue was it doesn't rebuild when we needed or package json changes with adding volumes we can make it work to show changes constantly_ _compose.yaml file for docker compose_

**Docker compose watch ->**

It listen to our changes and do (rebuilding app rerunning container etc) It automatically update our service container when we work

Three major things -

_sync_- moves changed file from our pc to right place in the container making sure everything is up-to date real time

rebuild- creation of new container images and then it update the services its beneficial when rolling out changes in production

_sync-restart_- Its good for development and testing


```# specify the version of docker-compose
version: "3.8"

# define the services/containers to be run
services:
  # define the frontend service
  # we can use any name for the service. A standard naming convention is to use "web" for the frontend
  web:
    # we use depends_on to specify that service depends on another service
    # in this case, we specify that the web depends on the api service
    # this means that the api service will be started before the web service
    depends_on: 
      - api
    # specify the build context for the web service
    # this is the directory where the Dockerfile for the web service is located
    build: ./frontend
    # specify the ports to expose for the web service
    # the first number is the port on the host machine
    # the second number is the port inside the container
    ports:
      - 5173:5173
    # specify the environment variables for the web service
    # these environment variables will be available inside the container
    environment:
      VITE_API_URL: http://localhost:8000

    # this is for docker compose watch mode
    # anything mentioned under develop will be watched for changes by docker compose watch and it will perform the action mentioned
    develop:
      # we specify the files to watch for changes
      watch:
        # it'll watch for changes in package.json and package-lock.json and rebuild the container if there are any changes
        - path: ./frontend/package.json
          action: rebuild
        - path: ./frontend/package-lock.json
          action: rebuild
        # it'll watch for changes in the frontend directory and sync the changes with the container real time
        - path: ./frontend
          target: /app
          action: sync

  # define the api service/container
  api: 
    # api service depends on the db service so the db service will be started before the api service
    depends_on: 
      - db

    # specify the build context for the api service
    build: ./backend
    
    # specify the ports to expose for the api service
    # the first number is the port on the host machine
    # the second number is the port inside the container
    ports: 
      - 8000:8000

    # specify environment variables for the api service
    # for demo purposes, we're using a local mongodb instance
    environment: 
      DB_URL: mongodb://db/anime
    
    # establish docker compose watch mode for the api service
    develop:
      # specify the files to watch for changes
      watch:
        # it'll watch for changes in package.json and package-lock.json and rebuild the container and image if there are any changes
        - path: ./backend/package.json
          action: rebuild
        - path: ./backend/package-lock.json
          action: rebuild
        
        # it'll watch for changes in the backend directory and sync the changes with the container real time
        - path: ./backend
          target: /app
          action: sync

  # define the db service
  db:
    # specify the image to use for the db service from docker hub. If we have a custom image, we can specify that in this format
    # In the above two services, we're using the build context to build the image for the service from the Dockerfile so we specify the image as "build: ./frontend" or "build: ./backend".
    # but for the db service, we're using the image from docker hub so we specify the image as "image: mongo:latest"
    # you can find the image name and tag for mongodb from docker hub here: https://hub.docker.com/_/mongo
    image: mongo:latest

    # specify the ports to expose for the db service
    # generally, we do this in api service using mongodb atlas. But for demo purposes, we're using a local mongodb instance
    # usually, mongodb runs on port 27017. So we're exposing the port 27017 on the host machine and mapping it to the port 27017 inside the container
    ports:
      - 27017:27017

    # specify the volumes to mount for the db service
    # we're mounting the volume named "anime" inside the container at /data/db directory
    # this is done so that the data inside the mongodb container is persisted even if the container is stopped
    volumes:
      - anime:/data/db

# define the volumes to be used by the services
volumes:
  anime:
``` 

compose.yml for mern stack app

**DOCKER SCOUT ->**
	 It used to debug the packages installed and outdated package  and vulnerability in our image

Installation command-\
	 `curl -fsSL https://raw.githubusercontent.com/docker/scout-cli/main/install.sh -o install-scout.sh`
`sh install-scout.sh`


TO view package dependencies in human readable form

 `docker scout sbom --format list [IMAGE]`
