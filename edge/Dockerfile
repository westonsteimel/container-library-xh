ARG VERSION="master"
ARG REVISION="c209ba541d346fcff8a58140e4f763b2388ef05b"

FROM ghcr.io/westonsteimel/rust-static-builder:stable as builder

ARG VERSION
ARG REVISION

RUN git clone --branch "${VERSION}" https://github.com/ducaale/xh /build/xh \
    && cd /build/xh \
    && git reset --hard "${REVISION}" \
    && NOCOMPRESS=1 /home/builder/build.sh

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
COPY --from=builder /build/artifacts/xh /usr/local/bin/xh

USER xh

ENTRYPOINT ["/usr/local/bin/xh"]
CMD ["--help"]

LABEL org.opencontainers.image.title="xh" \
    org.opencontainers.image.description="xh in a container" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.version="${VERSION}"

