FROM jenkins:latest
MAINTAINER "Rene Gielen" <rgielen@apache.org>

COPY install-default-plugins-and-run.sh /usr/local/bin/install-default-plugins-and-run.sh

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/install-default-plugins-and-run.sh", "/usr/local/bin/jenkins.sh"]