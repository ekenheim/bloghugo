# https://sko.ai/blog/how-to-actually-build-hugo-containers/
# FROM --platform=$BUILDPLATFORM alpine:3.13 as build
# RUN apk add --no-cache \
#     hugo \
#     dart-sass
# WORKDIR /src
# COPY . .
# RUN --mount=type=cache,target=/tmp/hugo_cache \
#     hugo
#
# FROM nginxinc/nginx-unprivileged
# COPY --from=build /src/public /usr/share/nginx/html
# EXPOSE 8080

# hadolint ignore=DL3006
FROM nginxinc/nginx-unprivileged
COPY /public /usr/share/nginx/html
EXPOSE 8080
