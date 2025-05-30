# Utilise NGINX comme image de base
FROM nginx:alpine

# Copie les fichiers de ton app dans le dossier HTML de NGINX
COPY . /usr/share/nginx/html

# Expose le port 80
EXPOSE 80
