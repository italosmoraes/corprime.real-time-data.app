# Real Time Data App

## Architecture

A server exposing websocket endpoints as sending real time data from a choosen source

## Design

dockerised apps
nestjs model
nextjs model, although on a simple FE

## Local run

make sure docker daemon is installed and running https://docs.docker.com/desktop/setup/install/mac-install/

```
docker compose up -d
```

or during development, to force container rebuild

```
docker compose up -d --build --force-recreate
```

### OR

Run the server and the app in separate terminals, if you want to bypass the docker usage for local run

## Data server

TODO link

## Web app

TODO link

## Deployment

TODO link to infra

1. Apply infrastructure using terraform

steps:
build image
publish image
push image to a repo
pull from repo
use image to update ec2
build and start apps

AWS
a small ec2 instance serving the FE
another instance maintaining the server alive
using terraform to describe the infra
and using aws cli to deploy the applications to the available infra

## Notes, improvements and next steps

- The apps were purposifully generic in name and nature
- The infrastructure was chosen to be straightforward
- Use of EC2 instances for simplicity, instead of using ECS for container orchestration
- Adding load balancers and auto-scaling groups for the ec2 instances is an option
- The web app uses nextjs so that we can have a fully featured framework (routers, auth, ssr) for when the app grows
- Improve resources names in aws to reflect environments
- Use https for the servers
- the current deployment of ec2 instances via terraform will mean downtime for the server while the instance is spun up. A load balancer or ECS cluster could be used as a solution.
- the usage of tailwindcss could be improved or better mixed with the custom css, given proper time
- the usage of TS types can be improved the 'any' used around for brevities sake
