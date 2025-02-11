# Use the official Node.js image.
FROM node:16-alpine

# Set the working directory.
WORKDIR /app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Install dependencies.
RUN npm install --only=production

# Copy the rest of the application code.
COPY . .

# Define the port the application will listen on.
ENV PORT=8080

# Start the application.
CMD ["node", "index.js"]
