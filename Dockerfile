# ETAPA 1: Compilación
FROM node:18-alpine AS build
WORKDIR /app

# 1. Copiamos tus archivos
COPY . .

# 2. Limpieza de rastro anterior
RUN rm -rf node_modules package.json package-lock.json

# 3. Instalamos explícitamente TAILWIND V3 (¡Aquí estaba la clave!)
RUN npm init -y
RUN npm install tailwindcss@3

# 4. Creamos la configuración
RUN echo "module.exports = { content: ['./index.html', './js/**/*.js'], theme: { extend: {} }, plugins: [] }" > tailwind.config.js

# 5. Creamos las directivas de entrada
RUN printf "@tailwind base;\n@tailwind components;\n@tailwind utilities;\n" > input.css
RUN if [ -f css/styles.css ]; then cat css/styles.css >> input.css; fi

# 6. COMPILAMOS (Ahora npx tailwindcss existe y funcionará a la primera)
RUN mkdir -p dist
RUN npx tailwindcss -i input.css -o dist/styles.css --minify

# ETAPA 2: Nginx
FROM nginx:alpine
COPY . /usr/share/nginx/html

# Sobrescribimos el CSS
COPY --from=build /app/dist/styles.css /usr/share/nginx/html/css/styles.css

# Activamos Gzip para volar en PageSpeed
RUN sed -i 's/gzip  on;/gzip on; gzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml+rss text\/javascript;/' /etc/nginx/nginx.conf

EXPOSE 80
