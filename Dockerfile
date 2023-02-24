FROM peaceiris/hugo:v0.110.0-mod AS builder
ARG VERSION=0.110.0
ARG BASEURL="https://anthoneous-github-io-anthoneous-main.pacenthink.co"
RUN apk add --no-cache git
WORKDIR /app
COPY . .
RUN git submodule update --init && hugo --minify --enableGitInfo -b ${BASEURL}

FROM nginx:1.23-alpine
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/nginx/nginx.conf /etc/nginx/
COPY --from=builder /app/nginx/app.conf /etc/nginx/conf.d
COPY --from=builder /app/public .
EXPOSE 8080
ENTRYPOINT ["nginx", "-g", "daemon off;"]
