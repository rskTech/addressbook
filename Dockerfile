# test
FROM bitnami/tomcat
ENV ALLOW_EMPTY_PASSWORD=yes
COPY addressbook.war /opt/bitnami/tomcat/webapps_default/addressbook.war
