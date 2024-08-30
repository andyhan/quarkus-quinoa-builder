ARG MAVEN_BASE_IMAGE=3-eclipse-temurin-21

FROM maven:${MAVEN_BASE_IMAGE}

USER root

ARG NODE_VERSION=lts

# Install NodeJS as root
# https://github.com/nodesource/distributions/blob/master/README.md#debinstall
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get update -qqy \
    && apt-get install -qqy gcc g++ make gettext nodejs \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Install pnpm via corepack
RUN corepack enable \
    && corepack prepare pnpm@latest-9 --activate \
    && pnpm config set --location=global registry "https://registry.npmmirror.com/"