# ETAPA 1: Compilación de Tailwind
FROM node:18-alpine AS build
WORKDIR /app
COPY . .
# Instalamos Tailwind CLI
RUN npm install -D tailwindcss
# Compilamos el CSS eliminando lo que no usas (Purge)
RUN npx tailwindcss -i ./css/styles.css -o ./dist/output.css --minify

# ETAPA 2: Servidor de producción
FROM nginx:alpine
# Copiamos los archivos estáticos
COPY . /usr/share/nginx/html
# Sobrescribimos el CSS con la versión minificada
COPY --from=build /app/dist/output.css /usr/share/nginx/html/css/styles.css

# Optimizamos Nginx para compresión Gzip
RUN sed -i 's/gzip  on;/gzip on; gzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml+rss text\/javascript;/' /etc/nginx/nginx.conf

EXPOSE 80
