# DEMO

# Use an official Node runtime as a parent image
FROM node:12

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies
RUN npm install

# Bundle app source
COPY . .

# Expose the port
EXPOSE 8080

# Command to run your application
CMD ["npm", "start"]
