FROM tomcat:8.0-alpine
COPY /tmp/box/target/hello-1.0.war /usr/local/tomcat/webapps/
