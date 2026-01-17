# Build Environment
FROM golang:1.23-bookworm AS builder

RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

ADD https://github.com/sass/dart-sass/releases/download/1.77.8/dart-sass-1.77.8-linux-x64.tar.gz /tmp/dart-sass.tar.gz

RUN tar -xzf /tmp/dart-sass.tar.gz -C /usr/local/bin/ \
    && mv /usr/local/bin/dart-sass/sass /usr/local/bin/sass \
    && rm /tmp/dart-sass.tar.gz

ARG HUGO_VERSION=0.128.0
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz /tmp/hugo.tar.gz

RUN tar -xzf /tmp/hugo.tar.gz -C /usr/local/bin/ \
    && rm /tmp/hugo.tar.gz

WORKDIR /src
COPY . .
RUN hugo --minify

#Production Server
FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /src/public /usr/share/nginx/html
EXPOSE 80