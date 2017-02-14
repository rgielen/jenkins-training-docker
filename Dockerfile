FROM jenkins:latest
MAINTAINER "Rene Gielen" <rgielen@apache.org>

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

USER root

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
            php5-cli \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && rm -rf /tmp/* \
      && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER ${user}

RUN /usr/local/bin/install-plugins.sh ant:latest \
                                      bitbucket:latest \
                                      bouncycastle-api:latest \
                                      build-timeout:latest \
                                      cloudbees-folder:latest \
                                      credentials-binding:latest \
                                      dashboard-view:latest \
                                      email-ext:latest \
                                      github:latest \
                                      github-organization-folder:latest \
                                      gradle:latest \
                                      icon-shim:latest \
                                      ldap:latest \
                                      m2release:latest \
                                      matrix-auth:latest \
                                      maven-dependency-update-trigger:latest \
                                      maven-plugin:latest \
                                      pipeline-maven:latest \
                                      pam-auth:latest \
                                      phing:latest \
                                      php:latest \
                                      ssh-slaves:latest \
                                      subversion:latest \
                                      timestamper:latest \
                                      windows-slaves:latest \
                                      workflow-aggregator:latest \
                                      ws-cleanup:latest
