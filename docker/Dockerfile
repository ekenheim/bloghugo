# https://sko.ai/blog/how-to-actually-build-hugo-containers/
FROM --platform=$BUILDPLATFORM docker.io/library/alpine:3.20@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d as build
RUN \
    apk add --no-cache \
      git \
      hugo \
      tzdata \
 && apk add --no-cache dart-sass --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/
WORKDIR /src
COPY . .
RUN --mount=type=cache,target=/tmp/hugo_cache \
    hugo --minify

FROM docker.io/library/nginx:1.26@sha256:42a11c50654d46498c9f0f1108e95cd82776a98e2b8632a3c1839dcd3ac23e0e
# implement changes required to run NGINX as an less-privileged user
RUN \
    sed -i 's,/var/run/nginx.pid,/tmp/nginx.pid,' /etc/nginx/nginx.conf \
 && sed -i "/^http {/a \    proxy_temp_path /tmp/proxy_temp;\n    client_body_temp_path /tmp/client_temp;\n    fastcgi_temp_path /tmp/fastcgi_temp;\n    uwsgi_temp_path /tmp/uwsgi_temp;\n    scgi_temp_path /tmp/scgi_temp;\n" /etc/nginx/nginx.conf \
 # nginx user must own the cache and etc directory to write cache and tweak the nginx config
 && chown -R 101:0 /var/cache/nginx \
 && chmod -R g+w /var/cache/nginx \
 && chown -R 101:0 /etc/nginx \
 && chmod -R g+w /etc/nginx

COPY --chown=nginx:nginx --from=build /src/public /site
COPY --chown=nginx:nginx ./docker/default.conf /etc/nginx/conf.d/

USER nginx
