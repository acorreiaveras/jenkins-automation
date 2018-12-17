FROM tomcat:8.0-jre8-alpine
ADD home/webapp /usr/local/tomcat/webapps/webapp
CMD ["catalina.sh", "run"] 
