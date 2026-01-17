FROM klakegg/hugo:ext-debian-ci AS builder
WORKDIR /src

COPY . .
RUN hugo --minify

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /src/public /usr/share/nginx/html
EXPOSE 80
