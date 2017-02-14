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
            sudo \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/* \
      && rm -rf /tmp/* \
      && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
      && curl -sSL https://get.docker.com/ | sh \
      && echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers \
      && usermod -aG docker ${user}

USER ${user}

RUN /usr/local/bin/install-plugins.sh ant:latest \
                                      ansicolor:latest \
                                      bitbucket:latest \
                                      blueocean:latest \
                                      bouncycastle-api:latest \
                                      build-timeout:latest \
                                      chucknorris:latest \
                                      cloudbees-folder:latest \
                                      conditional-buildstep:latest \
                                      credentials-binding:latest \
                                      dashboard-view:latest \
                                      docker-build-publish:latest \
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
                                      parameterized-trigger:latest \
                                      pipeline-githubnotify-step:latest \
                                      pipeline-maven:latest \
                                      pam-auth:latest \
                                      phing:latest \
                                      php:latest \
                                      rebuild:latest \
                                      run-condition:latest \
                                      ssh-slaves:latest \
                                      subversion:latest \
                                      timestamper:latest \
                                      unleash:latest \
                                      windows-slaves:latest \
                                      workflow-aggregator:latest \
                                      ws-cleanup:latest \
                                      xvfb:latest

# Failed to download, temporarily removed: email-ext:latest \
