# Dockerfile for NestJS Server

# Use a Node.js base image
FROM node:18-alpine as builder

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy the application code
COPY . .

# Build the application
RUN npm run build

# Use a lightweight Node.js image for the runtime
FROM node:16-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy built application from the builder stage
COPY --from=builder /usr/src/app/dist ./dist
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY package*.json .

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["node", "dist/src/main"]
