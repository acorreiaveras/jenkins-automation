FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y nginx
COPY index.html /usr/share/nginx/html/
COPY default /etc/nginx/sites-available/
ENTRYPOINT ["/usr/sbin/nginx","-g","daemon off;"]
EXPOSE 80
