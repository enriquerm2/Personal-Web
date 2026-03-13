# ETAPA 1: Compilación
FROM node:18-alpine AS build
WORKDIR /app

# 1. Instalamos Tailwind de forma GLOBAL (esto elimina el error de npx para siempre)
RUN npm install -g tailwindcss

# 2. Copiamos tus archivos
COPY . .

# 3. Creamos la configuración de forma segura
RUN echo "module.exports = { content: ['./**/*.html', './**/*.js'], theme: { extend: {} }, plugins: [] }" > tailwind.config.js

# 4. Creamos las directivas de Tailwind
RUN printf "@tailwind base;\n@tailwind components;\n@tailwind utilities;\n" > input.css

# 5. Sumamos estilos propios si existen
RUN if [ -f css/styles.css ]; then cat css/styles.css >> input.css; fi

# 6. Creamos la carpeta de salida y compilamos usando el comando GLOBAL (sin npx)
RUN mkdir -p dist
RUN tailwindcss -i input.css -o dist/styles.css --minify

# ETAPA 2: Nginx
FROM nginx:alpine
COPY . /usr/share/nginx/html

# Sobrescribimos el CSS con el bueno
COPY --from=build /app/dist/styles.css /usr/share/nginx/html/css/styles.css

# Activamos Gzip para volar en PageSpeed
RUN sed -i 's/gzip  on;/gzip on; gzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml+rss text\/javascript;/' /etc/nginx/nginx.conf

EXPOSE 80
