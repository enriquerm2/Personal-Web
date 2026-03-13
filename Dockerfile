# ETAPA 1: Compilación
FROM node:18-alpine AS build
WORKDIR /app
COPY . .

# 1. Iniciamos proyecto e instalamos Tailwind
RUN npm init -y
RUN npm install tailwindcss

# 2. Creamos la configuración ESPECÍFICA (Ignorando node_modules)
RUN echo "module.exports = { content: ['./index.html', './js/**/*.js'], theme: { extend: {} }, plugins: [] }" > tailwind.config.js

# 3. Creamos las directivas de entrada
RUN printf "@tailwind base;\n@tailwind components;\n@tailwind utilities;\n" > input.css
RUN if [ -f css/styles.css ]; then cat css/styles.css >> input.css; fi

# 4. COMPILAMOS (Ahora tardará 2 segundos porque no lee node_modules)
RUN mkdir -p dist
RUN ./node_modules/.bin/tailwindcss -i input.css -o dist/styles.css --minify

# ETAPA 2: Nginx
FROM nginx:alpine
COPY . /usr/share/nginx/html

# Sobrescribimos el CSS con el bueno
COPY --from=build /app/dist/styles.css /usr/share/nginx/html/css/styles.css

# Activamos Gzip para volar en PageSpeed
RUN sed -i 's/gzip  on;/gzip on; gzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml+rss text\/javascript;/' /etc/nginx/nginx.conf

EXPOSE 80
