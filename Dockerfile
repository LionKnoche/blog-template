# --- Build Stage ---
    FROM node:18-alpine AS builder-stage

    WORKDIR /app
    
    # 1) Notwendige Alpine-Pakete für Sharp
    RUN apk add --no-cache libc6-compat vips-dev
    
    # 2) package.json und pnpm-lock.yaml kopieren
    COPY package*.json ./
    COPY pnpm-lock.yaml ./
    
    # 3) pnpm installieren und Abhängigkeiten auflösen
    RUN npm install -g pnpm@10.3.0
    RUN pnpm install --frozen-lockfile
    
    # 4) Quellcode kopieren
    COPY . .
    
    # 5) Astro Build-Prozess
    RUN pnpm build
    
    # --- Production Stage ---
    FROM nginx:stable-alpine AS production-stage
    
    COPY --from=builder-stage /app/dist /usr/share/nginx/html
    
    EXPOSE 80
    ENTRYPOINT ["nginx", "-g", "daemon off;"]
    