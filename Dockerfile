FROM alpine:3.13

ENV PUBLIC_KEY DEFAULT

RUN apk add --update --no-cache openssh \
        vim \
    ; \
    rm -rf /tmp/* /var/cache/apk/*

ADD docker-entrypoint /usr/local/bin

RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

EXPOSE 22
ENTRYPOINT ["docker-entrypoint"]

CMD ["/usr/sbin/sshd","-D"]
