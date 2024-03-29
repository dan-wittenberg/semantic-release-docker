FROM --platform=$BUILDPLATFORM registry.access.redhat.com:443/ubi9/ubi-init:9.2-15.1697629656

RUN dnf update; dnf install -y git nodejs; dnf clean all

ENV NVM_DIR /root/.nvm
ENV NODE_VERSION 16.20.2

# Install nvm with node and npm
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash \
    && . "${NVM_DIR}"/nvm.sh \
    && nvm install "${NODE_VERSION}" \
    && nvm alias default "${NODE_VERSION}" \
    && nvm use default

WORKDIR /root
COPY ./ /root
RUN node -v
RUN npm install -g n; n v21.1.0
RUN npm install --save-dev semantic-release@v23.0.2
RUN npm install @semantic-release/git @semantic-release/changelog @semantic-release/exec -D

LABEL maintainer=AHEAD_Inc.

ENTRYPOINT ["/bin/sh"]
