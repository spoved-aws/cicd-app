# FROM jenkins/jenkins:2.426.2-jdk17
# USER root
# RUN echo "deb http://deb.debian.org/debian/ buster main" > /etc/apt/sources.list.d/buster.list \
#     && echo "deb http://security.debian.org/debian-security buster/updates main" >> /etc/apt/sources.list.d/buster.list \
#     && apt-get update \
#     && apt-get install -y openjdk-8-jdk
# RUN apt-get update && apt-get install -y lsb-release
# USER jenkins
# RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
FROM jenkins/jenkins:2.426.2-jdk17
USER root

# Add AdoptOpenJDK repository
RUN apt-get update && apt-get install -y wget apt-transport-https gnupg
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb buster main" > /etc/apt/sources.list.d/adoptopenjdk.list

# Install OpenJDK 8
RUN apt-get update && apt-get install -y adoptopenjdk-8-hotspot

USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
