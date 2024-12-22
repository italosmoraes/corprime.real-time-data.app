# Real time data server

Provides gateways to websockets that will stream data

## Nestjs server created using nestjs cli

```
npm install -g @nestjs/cli
nest generate application
```

Framework ref: https://github.com/nestjs/nest

## Local run:

`npm run start:dev`

Run the socketio util to verify local run:

```
npm install -g typescript ts-node

ts-node socketioClientBinance.ts
```

The utils found at `/server/utils` can be used to directly test the server via socket.io by running, for e.g:

```
 ts-node server/utils/socketioClientBinance.ts
```

### Real time data api

We use Binance web socket streams data:
https://developers.binance.com/docs/binance-spot-api-docs/web-socket-streams

## Deployment

### Deploy using nestjs Mau platform

It requires:

1. create aws users, policies and access keys to be used by mau
2. Create a project and an application via the mau dashboard
3. Deploy using the mau cli `mau deploy`

Refer to documentation: https://www.mau.nestjs.com/dashboard/documentation

Reference: https://www.mau.nestjs.com/

### Push docker images to ECR

Build new image:
`docker build -t real-time-server . --no-cache`

Tag and push to ECR:

```
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com
docker rmi --force $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/real_time_server_repo
docker tag real-time-server $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/real_time_server_repo
docker push $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/real_time_server_repo
```

Check details of new image pushed:
`aws ecr describe-images --repository-name real_time_server_repo --region eu-west-1`
