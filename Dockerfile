FROM jenkins:latest
MAINTAINER "Rene Gielen" <rgielen@apache.org>

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

USER root

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
            php-cli \
            sudo \
            ansible \
      && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
      && curl -sSL https://get.docker.com/ | sh \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
      && usermod -aG docker ${user} \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && rm -rf /tmp/*

# install maven
ENV MAVEN_VERSION 3.3.9
RUN cd /usr/local; wget -q -O - http://mirrors.ibiblio.org/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xvfz - && \
    ln -sv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven

USER ${user}

RUN /usr/local/bin/install-plugins.sh analysis-core:latest \
                                      analysis-collector:latest \
                                      ant:latest \
                                      antisamy-markup-formatter:latest \
                                      ansible:latest \
                                      ansicolor:latest \
                                      bitbucket:latest \
                                      blueocean:latest \
                                      bouncycastle-api:latest \
                                      build-monitor-plugin:latest \
                                      build-pipeline-plugin:latest \
                                      build-timeout:latest \
                                      checkstyle:latest \
                                      chucknorris:latest \
                                      cloudbees-folder:latest \
                                      conditional-buildstep:latest \
                                      credentials-binding:latest \
                                      dashboard-view:latest \
                                      docker-build-publish:latest \
                                      docker-build-step:latest \
                                      docker-plugin:latest \
                                      docker-slaves:latest \
                                      dry:latest \
                                      email-ext:latest \
                                      external-monitor-job:latest \
                                      findbugs:latest \
                                      ghprb:latest \
                                      gitbucket:latest \
                                      github:latest \
                                      github-oauth:latest \
                                      github-organization-folder:latest \
                                      gitlab-merge-request-jenkins:latest \
                                      gitlab-plugin:latest \
                                      gogs-webhook:latest \
                                      gradle:latest \
                                      groovy:latest \
                                      icon-shim:latest \
                                      job-dsl:latest \
                                      jobConfigHistory:latest \
                                      ldap:latest \
                                      m2release:latest \
                                      matrix-auth:latest \
                                      maven-dependency-update-trigger:latest \
                                      maven-plugin:latest \
                                      mock-slave:latest \
                                      nexus-artifact-uploader:latest \
                                      parameterized-trigger:latest \
                                      performance:latest \
                                      pipeline-githubnotify-step:latest \
                                      pipeline-maven:latest \
                                      pam-auth:latest \
                                      phing:latest \
                                      php:latest \
                                      pmd:latest \
                                      rebuild:latest \
                                      repository-connector:latest \
                                      run-condition:latest \
                                      ssh-slaves:latest \
                                      subversion:latest \
                                      timestamper:latest \
                                      unleash:latest \
                                      warnings:latest \
                                      windows-slaves:latest \
                                      workflow-aggregator:latest \
                                      ws-cleanup:latest \
                                      xvfb:latest

ADD JENKINS_HOME /usr/share/jenkins/ref
