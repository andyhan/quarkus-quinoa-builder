ARG MAVEN_BASE_IMAGE=3-eclipse-temurin-21
ARG MVND_VERSION=1.0.2

FROM maven:${MAVEN_BASE_IMAGE}

ARG NODE_VERSION=lts

ENV MVND_HOME=/opt/mvnd
ENV PATH="${MVND_HOME}/bin:${PATH}"
ENV MVND_BINARY_URL=https://downloads.apache.org/maven/mvnd/${MVND_VERSION}/maven-mvnd-${MVND_VERSION}-linux-amd64.tar.gz

USER root

# Install NodeJS as root
# https://github.com/nodesource/distributions/blob/master/README.md#debinstall
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get update -qqy \
    && apt-get install -qqy gcc g++ make gettext nodejs \    
    && mkdir -p /opt/mvnd && curl -fL $MVND_BINARY_URL | tar zxv -C /opt/mvnd --strip-components=1 \ 
    && ln -s ${MVND_HOME}/bin/mvnd /usr/bin/mvnd \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* 

# Install pnpm via corepack
RUN corepack enable \
    && corepack prepare pnpm@latest-9 --activate \
    && pnpm config set --location=global registry "https://registry.npmmirror.com/"
    
