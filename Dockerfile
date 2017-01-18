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

COPY install-default-plugins-and-run.sh /usr/local/bin/install-default-plugins-and-run.sh

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/install-default-plugins-and-run.sh", "/usr/local/bin/jenkins.sh"]