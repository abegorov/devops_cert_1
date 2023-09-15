FROM hashicorp/terraform:1.5
ENV TF_CLI_CONFIG_FILE=/etc/terraformrc
COPY --link terraformrc /etc/terraformrc
RUN apk update && \
    apk add openssh-keygen && \
    rm /var/cache/apk/* -rf
ENTRYPOINT []
