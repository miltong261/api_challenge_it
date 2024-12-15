FROM nginx:stable-alpine

ARG UID
ARG GID

ENV UID=${UID}
ENV GID=${GID}

# MacOS staff group's gid is 20, so is the dialout group in alpine linux. We're not using it, let's just remove it.
RUN delgroup dialout

RUN addgroup -g ${GID} --system challenge
RUN adduser -G challenge --system -D -s /bin/sh -u ${UID} challenge
RUN sed -i "s/user  nginx/user challenge/g" /etc/nginx/nginx.conf

ADD default.conf /etc/nginx/conf.d/
RUN mkdir -p /var/www/html
RUN mkdir -p /etc/nginx/ssl
RUN mkdir -p /var/www/acme-challenge