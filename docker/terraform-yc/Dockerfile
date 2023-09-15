FROM hashicorp/terraform:1.5
COPY --link terraformrc /root/.terraformrc
RUN apk update && \
    apk add openssh-keygen && \
    rm /var/cache/apk/* -rf
