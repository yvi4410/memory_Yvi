# Jeu du Memory

Ce repo permet de lancer un serveur web permettant de jouer au jeu du memory

## Architecture

Le dossier **html** contient les sources de notre site.

Le dossier **conf** contient le fichier de configuration nginx à utiliser pour notre site.

Cette configuration demande à nginx d'exposer le site se trouvant dans /var/concentration/html/


## Pour lancer le site

Remplacer le fichier de config nginx (/etc/nginx/nginx.conf) par notre config spécifique (conf/nginx.conf)

Ajouter nos sources dans /var/concentration/html/

Lancer le serveur nginx