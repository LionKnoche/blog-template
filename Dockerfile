# --- Build Stage ---
FROM node:18-alpine AS builder-stage

WORKDIR /app

COPY package*.json ./
COPY pnpm-lock.yaml ./

RUN npm install -g pnpm@10.3.0
RUN pnpm install --frozen-lockfile # Saubere Installation mit Lockfile

COPY . .

RUN pnpm build # Astro Build Prozess ausführen


# --- Production Stage ---
FROM nginx:stable-alpine AS production-stage

COPY --from=builder-stage /app/dist /usr/share/nginx/html

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
