FROM alpine:3.17.1 AS builder
ARG VERSION=0.110.0
ADD https://github.com/gohugoio/hugo/releases/download/v0.110.0/hugo_extended_0.110.0_darwin-universal.tar.gz /hugo.tar.gz
RUN tar -zxvf hugo.tar.gz && \
    rm -rf hugo.tar.gz && \
    apk add --no-cache git
WORKDIR /app
COPY . .
RUN git submodule update --init 

FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/
COPY --from=builder /app/nginx/app.conf /etc/nginx/conf.d
COPY --from=builder /app/public .
EXPOSE 8080
ENTRYPOINT ["nginx", "-g", "daemon off;"]
