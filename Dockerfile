FROM eclipse-temurin:11-jdk-jammy as jdk11

# Multi-Arch build example:
# docker buildx create --name multiarch-builder
# docker buildx use multiarch-builder
# docker buildx build --no-cache --pull --push --platform linux/arm64/v8,linux/amd64 --tag rgielen/jenkins-training .

RUN $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM eclipse-temurin:17-jdk-jammy as jdk17

RUN $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM eclipse-temurin:21-jdk-jammy as jdk21

RUN $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM jenkins/jenkins:lts-jdk17
LABEL maintainer="Rene Gielen <rgielen@apache.org>"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

USER root

ENV DOCKER_COMPOSE_VERSION 1.29.2

COPY --from=jdk11 /javaruntime /opt/java/jdk11
COPY --from=jdk17 /javaruntime /opt/java/jdk17
COPY --from=jdk21 /javaruntime /opt/java/jdk21

RUN apt-get update && apt-get upgrade -y \
      && apt-get install -y --no-install-recommends \
            php-cli \
            sudo \
            ansible \
            wget \
      && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
      && curl -sSL https://get.docker.com/ | sh \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
      && usermod -aG docker ${user} \
      && curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
      && curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash \
      && chmod +x /usr/local/bin/docker-compose \
      && chmod u+s $(which docker) \
      && chmod u+s $(which docker-compose) \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && rm -rf /tmp/*

# install maven
ENV MAVEN_VERSION 3.9.6
RUN cd /usr/local; wget -q -O - https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xvfz - && \
    ln -sv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven

USER ${user}

# Suggested Plugins
# https://github.com/jenkinsci/jenkins/blob/master/core/src/main/resources/jenkins/install/platform-plugins.json
RUN jenkins-plugin-cli --plugins cloudbees-folder \
                                 antisamy-markup-formatter \
                                 build-timeout \
                                 credentials-binding \
                                 timestamper \
                                 ws-cleanup \
                                 ant \
                                 gradle \
                                 workflow-aggregator \
                                 pipeline-github-lib \
                                 pipeline-stage-view \
                                 git \
                                 ssh-slaves \
                                 matrix-auth \
                                 pam-auth \
                                 ldap \
                                 email-ext \
                                 mailer

# Additional choice of useful plugins
RUN jenkins-plugin-cli --plugins ansicolor \
                                 build-monitor-plugin \
                                 chucknorris \
                                 conditional-buildstep \
                                 config-file-provider \
                                 configuration-as-code \
                                 copyartifact \
                                 dashboard-view \
                                 dependency-check-jenkins-plugin \
                                 docker-build-publish \
                                 docker-build-step \
                                 docker-compose-build-step \
                                 dockerhub-notification \
                                 docker-plugin \
                                 docker-workflow \
                                 emailext-template \
                                 external-monitor-job \
                                 folder-auth \
                                 github-checks \
                                 github-oauth \
                                 gitlab-plugin \
                                 groovy \
                                 job-dsl \
                                 jobConfigHistory \
                                 junit \
                                 junit-attachments \
                                 m2release \
                                 mattermost \
                                 maven-plugin \
                                 mock-slave \
                                 nexus-artifact-uploader \
                                 oic-auth \
                                 parameterized-trigger \
                                 performance \
                                 pipeline-maven \
                                 rebuild \
                                 role-strategy \
                                 ssh-agent \
                                 ssh-steps \
                                 versioncolumn \
                                 versionnumber \
                                 warnings-ng \
                                 xvfb

ADD JENKINS_HOME /usr/share/jenkins/ref
