FROM hashicorp/terraform:1.5
COPY --link terraformrc /root/
RUN apk update && \
    apk add openssh-keygen && \
    rm /var/cache/apk/* -rf
