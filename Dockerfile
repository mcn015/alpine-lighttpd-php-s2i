FROM alpine:3.7
MAINTAINER Miquel Canals <mcn015@uib.es>

ENV STI_SCRIPTS_PATH=/usr/libexec/s2i \
    EXEC=/run/lighttpd/ \
    WWW=/var/www

LABEL io.k8s.description="S2i Image of Alpine Linux with lighttpd and php" \
      io.k8s.display-name="S2I lighttpd" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder, lighttpd, php, alpine" \
      io.openshift.s2i.scripts-url=image://${STI_SCRIPTS_PATH}
 \
#install packages
RUN apk --update add \
    lighttpd  \
    php7-common \
    php7-iconv \
    php7-json \
    php7-gd \
    php7-curl \
    php7-xml \
    php7-pgsql \
    php7-imap \
    fcgi \
    php7-pdo \
    php7-pdo_pgsql \
    php7-soap \
    php7-xmlrpc \
    php7-posix \
    php7-mcrypt \
    php7-gettext \
    php7-ldap \
    php7-ctype \
    php7-cgi \
    # openrc \
    bash \
    php7-dom && \
    rm -rf /var/cache/apk/*

# set config \
COPY lighttpd.conf /etc/lighttpd/lighttpd.conf
COPY ./s2i/bin/ ${STI_SCRIPTS_PATH}

# set default user \
RUN  adduser -s /bin/sh -u 1001 -G root -H -S -D default \
  && mkdir -p ${EXEC} \
  && mkdir -p ${WWW} \
  && chown -R 1001:0 ${EXEC} \
  && chmod -R 755 ${EXEC} \
  && chown -R 1001:0 ${WWW} \
  && chmod -R 755 ${WWW} \
  && chmod -R 775 ${STI_SCRIPTS_PATH}

USER 1001

EXPOSE 8080

# CMD bash

# Set the default CMD to print the usage of the image, if somebody does docker
CMD ["${STI_SCRIPTS_PATH}/usage"]
