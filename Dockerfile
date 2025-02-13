# --- Build Stage ---
    FROM node:18-alpine AS builder-stage

    WORKDIR /app
    
    # 1) Systembibliotheken installieren, die Sharp braucht
    RUN apk add --no-cache libc6-compat vips-dev
    
    # 2) package.json / pnpm-lock.yaml kopieren
    COPY package*.json ./
    COPY pnpm-lock.yaml ./
    
    # 3) pnpm installieren und Dependencies auflösen
    RUN npm install -g pnpm@10.3.0
    RUN pnpm install --frozen-lockfile
    
    # 4) Quellcode kopieren
    COPY . .
    
    # 5) Astro Build-Prozess
    RUN pnpm build
    
    # --- Production Stage ---
    FROM nginx:stable-alpine AS production-stage
    
    # Gebautes Projekt in den NGINX-Ordner kopieren
    COPY --from=builder-stage /app/dist /usr/share/nginx/html
    
    EXPOSE 80
    
    ENTRYPOINT ["nginx", "-g", "daemon off;"]
    