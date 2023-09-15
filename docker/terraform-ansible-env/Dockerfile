FROM alpine:3.18 AS builder

RUN --mount=type=cache,target=/var/cache/apk <<EOT
    set -eux
    apk update
    apk add openssh-keygen
EOT

RUN --mount=type=cache,target=/var/cache/apk <<EOT
    set -eux
    apk update
    apk add terraform
EOT
ENV TF_CLI_CONFIG_FILE=/etc/terraformrc
COPY --link terraformrc /etc/terraformrc

RUN --mount=type=cache,target=/var/cache/apk <<EOT
    set -eux
    apk update
    apk add ansible
EOT
