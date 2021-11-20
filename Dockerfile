FROM tomcat:8.0

# Maintainer
MAINTAINER "Bipin Singh"

# COPY path-to-your-application-war path-to-webapps-in-docker-tomcat
COPY ./java-tomcat-sample-docker/target/java-tomcat-maven-example.war /usr/local/tomcat/webapps

EXPOSE 8080

CMD ["catalina.sh", "run"]
