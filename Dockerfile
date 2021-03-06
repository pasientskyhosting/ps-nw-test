FROM debian:stretch-slim

MAINTAINER Andreas Krüger <ak@patientsky.com>

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ENV TINI_VERSION v0.18.0

RUN apt-get update && apt-get install -y -q --install-recommends --no-install-suggests \
        wget \
        host \
        net-tools \
        tzdata \
        ca-certificates \
        telnet \
        tcpdump \
        curl \
        gnupg2 \
        procps \
        parallel \
        vim \
        iputils-ping \
        dnsutils \
    && wget https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -O /tini \
    && chmod +x /tini \
    && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - \
    && echo "deb http://nginx.org/packages/mainline/debian/ stretch nginx" > /etc/apt/sources.list.d/nginx.list \
    && echo "deb-src http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list.d/nginx.list \
    && apt-get update \
    && apt-get install -y -q --no-install-recommends --no-install-suggests \
        nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY nw.sh /nw.sh
COPY snat-race-conn-test /snat-race-conn-test
COPY curl-format.txt /curl-format.txt

EXPOSE 80

ENTRYPOINT ["/tini", "--"]
CMD ["/usr/sbin/nginx"]
