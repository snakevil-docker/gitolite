FROM registry.cn-hangzhou.aliyuncs.com/snakevil/base
MAINTAINER Snakevil Zen <zsnakevil@gmail.com>

ARG version=latest

EXPOSE 22
VOLUME /mnt/git

RUN BUILD_DATE=20161021 \
 && apk add --no-cache openssh git perl
ADD share/docker/ var/lib/gitolite-${version}.tar.xz /

RUN chown -R root:root /srv \
 && sed -i -e "1iAllowUsers git" \
        -e "1iAuthenticationMethods publickey" \
        -e "1iChallengeResponseAuthentication no" \
        -e "1iPrintMotd no" \
        -e "1iTCPKeepAlive no" \
        -e "/^$/d;/^#/d" /etc/ssh/sshd_config \
 && mkdir -m 0600 /root/.ssh \
 && echo "Host localhost" > /root/.ssh/config \
 && echo "  HostName 127.0.0.1" >> /root/.ssh/config \
 && echo "  RequestTTY no" >> /root/.ssh/config \
 && echo "  StrictHostKeyChecking no" >> /root/.ssh/config \
 && git config --global user.name root \
 && git config --global user.email root@gitolite \
 && adduser -h /mnt/git -s /bin/sh -G nobody -S -D git \
 && passwd -u git

# vi:sw=4:tw=120:
