FROM nginx:latest

RUN apt-get update && apt-get install -y file 

RUN mkdir -p /var/concentration/html

COPY html/ /var/concentration/html/

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

