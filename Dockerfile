FROM jboss/keycloak:3.4.3.Final

ENV M2_HOME /usr/local/apache-maven
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

USER root

RUN yum install -y wget

# install maven
RUN mkdir -p /tmp/maven
WORKDIR /tmp/maven
RUN wget http://apache.mirrors.ionfish.org/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz \
    && wget https://www.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz.md5 \
    && echo '  apache-maven-3.5.3-bin.tar.gz' >> apache-maven-3.5.3-bin.tar.gz.md5 \
    && md5sum -c apache-maven-3.5.3-bin.tar.gz.md5
RUN tar xvf apache-maven-3.5.3-bin.tar.gz
RUN mv apache-maven-3.5.3  /usr/local/apache-maven

# Build and install keycloak example libraries
WORKDIR /opt/jboss
USER jboss
COPY --chown=jboss:jboss _srv/keycloak-demo-3.4.3.Final ./_srv/keycloak-demo-3.4.3.Final
WORKDIR _srv/keycloak-demo-3.4.3.Final/examples
RUN mvn -U clean install
WORKDIR /opt/jboss


