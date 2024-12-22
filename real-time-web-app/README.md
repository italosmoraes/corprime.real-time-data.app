This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

Next.js: https://github.com/vercel/vercel

## Local run

```
npm run dev
```

Open http://localhost:80

## Local Docker Run

Build new image:
`docker build -t real-time-webapp . --no-cache`

Run container:
`docker run -d -dp 80:80 --name webapp real-time-webapp`

## Deployment

Deployment is done via vercel cli: https://vercel.com/docs/cli

To deploy to a private test url:
`vercel`

To deploy to an online available url:
`vercel --prod`

ensure environment variables are available to vercel:
`https://vercel.com/<projects>/<application>/settings/environment-variables`

## Deploy via AWS

### Push docker images to ECR

Build new image:
`docker build -t real-time-web-app . --no-cache`

Tag and push to ECR:

```
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com
docker rmi --force $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/realtime_data_webapp
docker tag real-time-web-app $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/realtime_data_webapp_repo
docker push $AWS_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/realtime_data_webapp_repo
```

Check details of new image pushed:
`aws ecr describe-images --repository-name realtime_data_webapp_repo --region eu-west-1`
