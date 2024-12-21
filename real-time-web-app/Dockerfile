# Dockerfile for Next.js App

# Use a Node.js base image
FROM node:18-alpine as builder

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the application code
COPY . .

# Build the Next.js app
RUN npm run build

# Use a lightweight Node.js image for the runtime
FROM node:18-alpine

# Set working directory
WORKDIR /usr/src/app

# Copy built application from the builder stage
COPY --from=builder /usr/src/app .

# Expose the application port
EXPOSE 80

# Command to run the application
CMD ["npm", "run", "start"]
