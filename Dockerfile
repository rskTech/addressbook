# test
FROM bitnami/tomcat
ENV ALLOW_EMPTY_PASSWORD=yes
COPY target/addressbook.war /opt/bitnami/tomcat/webapps_default/addressbook.war
