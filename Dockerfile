# ETAPA 1: Compilación de Tailwind
FROM node:18-alpine AS build
WORKDIR /app
COPY . .

# 1. Creamos un package.json si no existe para evitar errores de npm
RUN if [ ! -f package.json ]; then echo '{"name":"web","version":"1.0.0"}' > package.json; fi

# 2. Instalamos Tailwind
RUN npm install -D tailwindcss

# 3. AUTO-CORRECCIÓN: Creamos el config de Tailwind si no existe
RUN echo 'module.exports = { content: ["./index.html", "./js/**/*.js"], theme: { extend: {} }, plugins: [], }' > tailwind.config.js

# 4. AUTO-CORRECCIÓN: Generamos un archivo CSS de entrada con las directivas necesarias
# Esto asegura que Tailwind sepa qué compilar aunque tu archivo css/styles.css sea normal
RUN mkdir -p css && echo -e "@tailwind base;\n@tailwind components;\n@tailwind utilities;\n$(cat css/styles.css 2>/dev/null || echo '')" > css/input.css

# 5. Compilamos (Cambiamos el destino a dist/styles.css)
RUN npx tailwindcss -i css/input.css -o dist/styles.css --minify

# ETAPA 2: Servidor de producción con Nginx
FROM nginx:alpine
COPY . /usr/share/nginx/html

# Sobrescribimos el CSS con la versión real procesada y minificada
COPY --from=build /app/dist/styles.css /usr/share/nginx/html/css/styles.css

# Optimizamos Nginx para que la web vuele (Gzip)
RUN sed -i 's/gzip  on;/gzip on; gzip_types text\/plain text\/css application\/json application\/javascript text\/xml application\/xml application\/xml+rss text\/javascript;/' /etc/nginx/nginx.conf

EXPOSE 80
