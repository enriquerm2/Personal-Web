# Usamos Nginx para servir archivos estáticos
FROM nginx:alpine

# Copiamos todo el contenido de tu repo a la carpeta de la web de Nginx
COPY . /usr/share/nginx/html

# Exponemos el puerto 80
EXPOSE 80
