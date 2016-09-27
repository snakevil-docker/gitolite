# Gitolite

FROM alpine:3.4
MAINTAINER Snakevil Zen <zsnakevil@gmail.com>

ARG version=latest

EXPOSE 22
VOLUME /var/git
ENTRYPOINT [ "/srv/up" ]

ADD include/etc/localtime /etc/
RUN BUILD_DATE=20160924 && \
    sed -i -e "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/" /etc/apk/repositories && \
    apk add --no-cache openssh git perl
ADD var/lib/gitolite-${version}.tar.xz src/srv/up /srv/
RUN chown -R root:root /srv /etc/localtime && \
    sed -i -e "1iAllowUsers git" \
        -e "1iAuthenticationMethods publickey" \
        -e "1iChallengeResponseAuthentication no" \
        -e "1iPrintMotd no" \
        -e "1iTCPKeepAlive no" \
        -e "/^$/d;/^#/d" /etc/ssh/sshd_config && \
    ssh-keygen -b 1024 -t dsa -N "" -C "dsa host key" -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -b 256 -t ecdsa -N "" -C "ecdsa host key" -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -b 256 -t ed25519 -N "" -C "ed25519 host key" -f /etc/ssh/ssh_host_ed25519_key && \
    ssh-keygen -b 1024 -t rsa -N "" -C "rsa host key" -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -b 1024 -N "" -C "root@gitolite" -f /root/.ssh/id_rsa && \
    echo "Host localhost" > /root/.ssh/config && \
    echo "  HostName 127.0.0.1" >> /root/.ssh/config && \
    echo "  RequestTTY no" >> /root/.ssh/config && \
    echo "  StrictHostKeyChecking no" >> /root/.ssh/config && \
    git config --global user.name root && \
    git config --global user.email root@gitolite && \
    adduser -h /var/git -s /bin/sh -G ping -S -D -u 999 git && \
    passwd -u git

# vi:sw=4:tw=120:
