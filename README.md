# Real Time Data App

A simple application which shows a chart with financial data, specifically for BITCOIN/USD trades, streamed from binance when connected to our nestjs server stream

Application available at https://corprimereal-time-datawebapp.vercel.app/

## Architecture

A server exposing websocket endpoints as sending real time data from a choosen source

Simple Nextjs front end application, which opens a websocket to the nestjs server

Nestjs backend connecting to binance web streams

## Design

Dockerised application for deployment and local development usage

Following the nestjs design of modules which include controllers and services

## Local run

1. Install nest cli

```
 npm i -g @nestjs/cli
```

2. Navigate to /server and `npm run install`

3. make sure docker daemon is installed and running https://docs.docker.com/desktop/setup/install/mac-install/ and then,

```
docker compose up -d
```

or during development, to force container rebuild

```
docker compose up -d --build --force-recreate
```

## Server

[server](/server/README.md)

## Web app

[web-app](real-time-web-app/README.md)

## Deployment

The webapp and server are deployed independently. Refer to their deployment sections in the README.

## Notes on development

### General

- The apps were purposifully generic in name and nature, reflecting it is a real time application to get data from a source
- The web app uses nextjs so that we can have a fully featured framework (routers, auth, ssr) for when the app grows
- The infrastructure was chosen to be straightforward, deploying via vercel and mau, which are the basic ones for the FE and BE frameworks used

### Improvemements

- More endpoints can be added with further study of the binance streams used
- The usage of TS types can be improved the 'any' used around for brevities sake
- The usage of tailwindcss could be improved or better mixed with the custom css, given more time
- Chart.js offers more options for data display customisation
