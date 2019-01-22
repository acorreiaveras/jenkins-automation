FROM tomcat:8.5-jre8-alpine
WORKDIR /usr/share/tomcat6-myapp/myapp
COPY index.html /usr/share/tomcat6-myapp/myapp/index.html
COPY myapp.xml /ect/tomcat6/Catalina/localhost
CMD ["catalina.sh", "run"]  
