FROM tomcat:8.5
ADD sample.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]
