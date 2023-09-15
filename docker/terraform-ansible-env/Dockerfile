FROM alpine:3.18 AS builder

RUN --mount=type=cache,target=/var/cache/apk <<EOT
    set -eux
    apk update
    apk add openssh-client
    apk add openssh-keygen
EOT

RUN --mount=type=cache,target=/var/cache/apk <<EOT
    set -eux
    apk update
    apk add terraform
EOT

RUN --mount=type=cache,target=/var/cache/apk <<EOT
    set -eux
    apk update
    apk add ansible
EOT

# ansible необходима возможность записи в $HOME:
ENV HOME=/tmp
# настройки Terraform для работы с https://terraform-mirror.yandexcloud.net/:
ENV TF_CLI_CONFIG_FILE=/etc/terraformrc
COPY --link terraformrc ${TF_CLI_CONFIG_FILE}
