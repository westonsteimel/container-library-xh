ARG VERSION="master"
ARG REVISION="456770f4ab0f7ca6535c8a4ed0fb9c9f2fb98bc4"

FROM docker.io/rust:alpine as builder

ARG VERSION
ARG REVISION

RUN apk update && apk add --no-cache \
    git \
    ca-certificates \
    build-base \
    musl-utils \
    musl-dev

RUN git clone --branch "${VERSION}" https://github.com/ducaale/xh /build/xh \
    && cd /build/xh \
    && git reset --hard "${REVISION}" \
    && RUSTFLAGS='-C link-arg=-s' cargo build --release --bins --target-dir /build/

FROM alpine:latest as config

RUN addgroup xh \
    && adduser -G xh -s /bin/sh -D xh

FROM scratch

ARG VERSION
ARG REVISION
ENV XH_VERSION="${VERSION}" \
    XH_REVISION="${REVISION}" \
    TERM="xterm-256color"

COPY --from=config /etc/passwd /etc/passwd
COPY --from=builder /build/release/xh /usr/local/bin/xh

USER xh

ENTRYPOINT ["/usr/local/bin/xh"]
CMD ["--help"]

LABEL org.opencontainers.image.title="xh" \
    org.opencontainers.image.description="xh in a container" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.version="${VERSION}"

