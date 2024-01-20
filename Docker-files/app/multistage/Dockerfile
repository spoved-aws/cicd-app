FROM openjdk:11 AS BUILD_IMAGE
RUN apt update && apt install maven -y
RUN git clone https://github.com/spoved-aws/cicd-app.git
RUN cd cicd-app && git checkout cicd-jenkins-local  mvn install -f pom-for-dockerfile.xml
CMD ["catalina.sh", "run"]

FROM tomcat:9-jre11
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE cicd-app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8079
CMD ["catalina.sh", "run"]