FROM eclipse-temurin:11-jdk-focal as jdk11

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

FROM eclipse-temurin:17-jdk-focal as jdk17

RUN $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM azul/zulu-openjdk:21 as jdk21

RUN $JAVA_HOME/bin/jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --no-header-files \
         --compress=2 \
         --output /javaruntime

FROM jenkins/jenkins:lts
MAINTAINER "Rene Gielen" <rgielen@apache.org>

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
ENV MAVEN_VERSION 3.9.4
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

#RUN /usr/local/bin/install-plugins.sh ant:latest \
#                                      antisamy-markup-formatter:latest \
#                                      ansible:latest \
#                                      ansicolor:latest \
#                                      bitbucket:latest \
#                                      blueocean:latest \
#                                      blueocean-pipeline-editor:latest \
#                                      bouncycastle-api:latest \
#                                      build-monitor-plugin:latest \
#                                      build-pipeline-plugin:latest \
#                                      build-timeout:latest \
#                                      chucknorris:latest \
#                                      cloudbees-folder:latest \
#                                      conditional-buildstep:latest \
#                                      credentials-binding:latest \
#                                      dashboard-view:latest \
#                                      dependency-check-jenkins-plugin \
#                                      docker-build-publish:latest \
#                                      docker-build-step:latest \
#                                      docker-compose-build-step:latest \
#                                      dockerhub-notification:latest \
#                                      docker-plugin:latest \
#                                      docker-slaves:latest \
#                                      email-ext:latest \
#                                      external-monitor-job:latest \
#                                      ghprb:latest \
#                                      github:latest \
#                                      github-oauth:latest \
#                                      gitlab-merge-request-jenkins:latest \
#                                      gitlab-plugin:latest \
#                                      gradle:latest \
#                                      groovy:latest \
#                                      job-dsl:latest \
#                                      jobConfigHistory:latest \
#                                      junit-attachments:latest \
#                                      ldap:latest \
#                                      m2release:latest \
#                                      matrix-auth:latest \
#                                      mattermost:latest \
#                                      maven-dependency-update-trigger:latest \
#                                      maven-plugin:latest \
#                                      mock-slave:latest \
#                                      nexus-artifact-uploader:latest \
#                                      oic-auth:latest \
#                                      parameterized-trigger:latest \
#                                      performance:latest \
#                                      pipeline-githubnotify-step:latest \
#                                      pipeline-maven:latest \
#                                      pam-auth:latest \
#                                      phing:latest \
#                                      rebuild:latest \
#                                      repository-connector:latest \
#                                      role-strategy:latest \
#                                      run-condition:latest \
#                                      ssh:latest \
#                                      ssh-agent:latest \
#                                      ssh-slaves:latest \
#                                      ssh-steps:latest \
#                                      subversion:latest \
#                                      timestamper:latest \
#                                      unleash:latest \
#                                      warnings-ng:latest \
#                                      windows-slaves:latest \
#                                      workflow-aggregator:latest \
#                                      ws-cleanup:latest \
#                                      xvfb:latest

ADD JENKINS_HOME /usr/share/jenkins/ref
