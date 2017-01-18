FROM jenkins:latest
MAINTAINER "Rene Gielen" <rgielen@apache.org>

COPY install-default-plugins.sh /usr/local/bin/install-default-plugins.sh

ENTRYPOINT ["install-default-plugins.sh && /bin/tini", "--", "/usr/local/bin/jenkins.sh"]