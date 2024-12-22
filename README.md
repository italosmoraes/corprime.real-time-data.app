# Real Time Data App

## Architecture

A server exposing websocket endpoints as sending real time data from a choosen source

## Design

dockerised apps
nestjs model
nextjs model, although on a simple FE

## Local docker run

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

## Server

[server](/server)

## Web app

[web-app](real-time-web-app)

## Deployment

The webapp and server are deployed independently. Refer to their deployment sections in the README.

## Notes on development

### General

- The apps were purposifully generic in name and nature, reflecting it is a real time application to get data from a source
- The web app uses nextjs so that we can have a fully featured framework (routers, auth, ssr) for when the app grows
- The infrastructure was chosen to be straightforward, deploying via vercel and mau, which are the basic ones for the FE and BE frameworks used

### Improvemements

- The usage of TS types can be improved the 'any' used around for brevities sake
- The usage of tailwindcss could be improved or better mixed with the custom css, given more time
