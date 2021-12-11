FROM centos
# Installing Java
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV PATH=$PATH:$JAVA_HOME
RUN yum install java-1.8.0-openjdk-devel wget git -y
EXPOSE 8080

# Installing Maven
ENV Mvn_Version=3.8.4
ENV M2_HOME=/usr/local/apache-maven/apache-maven-${Mvn_Version}
ENV M2="${M2_HOME}/bin"
ENV PATH=$PATH:$M2

RUN wget https://downloads.apache.org/maven/maven-3/${Mvn_Version}/binaries/apache-maven-${Mvn_Version}-bin.tar.gz && \
    tar xvfz apache-maven-${Mvn_Version}-bin.tar.gz && \
    mkdir /usr/local/apache-maven/apache-maven-${Mvn_Version} -p && \
    mv apache-maven-${Mvn_Version}/* /usr/local/apache-maven/apache-maven-${Mvn_Version}/


# Installing and configuring Tomcat
ARG test
ENV Tomcat_Version=9.0.56
RUN     wget http://www-eu.apache.org/dist/tomcat/tomcat-9/v${Tomcat_Version}/bin/apache-tomcat-${Tomcat_Version}.tar.gz && \
        tar xvfz apache-tomcat-${Tomcat_Version}.tar.gz && \
        mkdir -p /opt/tomcat/ /opt/myapplication/ -p && \
        mv apache-tomcat-${Tomcat_Version}.tar.gz /tmp/ && \
        mv apache-tomcat-${Tomcat_Version}/* /opt/tomcat/.
COPY context.xml /opt/tomcat/webapps/manager/META-INF/
COPY tomcat-users.xml /opt/tomcat/conf/
COPY /target/spring3-mvc-maven-xml-hello-world-1.0-SNAPSHOT.war /opt/tomcat/webapps/app.war
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
