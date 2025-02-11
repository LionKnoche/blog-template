# Use a Node.js base image for building
FROM node:18-alpine as builder

WORKDIR /app

COPY package*.json ./

RUN npm install # or pnpm install or yarn install

COPY . .

# Build the Astro site
RUN npm run build  # or pnpm build or yarn build

# Use a smaller image to serve the static files (Nginx is common)
FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 (default HTTP port)
EXPOSE 80

# Nginx serves the static files by default
