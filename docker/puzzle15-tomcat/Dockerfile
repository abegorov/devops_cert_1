FROM alpine:3.18 AS builder
RUN apk update && \
    apk add openjdk8 && \
    apk add maven && \
    apk add git && \
    rm /var/cache/apk/* -rf
WORKDIR /build
RUN git clone https://github.com/venkaDaria/puzzle15.git .
COPY --link pom.xml ./
RUN rm target -rf && \
    rm target_heroku -rf && \
    mvn clean && \
    mvn package && \
    rm /root/.m2 -rf

FROM alpine:3.18
RUN apk update && \
    apk add openjdk8-jre-base && \
    rm /var/cache/apk/* -rf
ENV TOMCAT_MAJOR 9
ENV TOMCAT_VERSION 9.0.80
ENV CATALINA_HOME /opt/tomcat
WORKDIR $CATALINA_HOME
RUN wget -O /tmp/tomcat.tar.gz https://dlcdn.apache.org/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && \
    tar xf /tmp/tomcat.tar.gz --strip-components 1 --directory . && \
    rm webapps/* -rf && \
    rm /tmp/tomcat.tar.gz
EXPOSE 8080
CMD [ "bin/catalina.sh", "run" ]
COPY --from=builder --link /build/target/ROOT.war ./webapps/
