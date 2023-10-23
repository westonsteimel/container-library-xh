ARG XH_REPOSITORY="https://github.com/ducaale/xh"
ARG XH_VERSION="0.19.4"
ARG XH_BRANCH="v0.19.4"
ARG XH_COMMIT="d34e0537eea5d939b55f60be8af58741cd33fb67"

FROM docker.io/rust:alpine as builder
COPY package-metadata.spec /build/

ARG XH_REPOSITORY \
    XH_VERSION \
    XH_BRANCH \
    XH_COMMIT

RUN apk update && apk add --no-cache \
    git \
    ca-certificates \
    build-base \
    musl-utils \
    musl-dev

RUN cargo install cargo-auditable

RUN git clone --branch "${XH_BRANCH}" "${XH_REPOSITORY}" /build/xh \
    && export ARCHITECTURE=$(arch) \
    && cd /build/xh \
    && git reset --hard "${XH_COMMIT}" \
    && RUSTFLAGS='-C link-arg=-s -C link-arg=-specs=/build/package-metadata.spec' cargo auditable build --release --bins --target-dir /build/

FROM alpine:latest as config

RUN addgroup xh \
    && adduser -G xh -s /bin/sh -D xh

FROM scratch

ARG XH_REPOSITORY \
    XH_VERSION \
    XH_BRANCH \
    XH_COMMIT

ENV XH_REPOSITORY="${XH_REPOSITORY}" \
    XH_VERSION="${XH_VERSION}" \
    XH_BRANCH="${XH_BRANCH}" \
    XH_COMMIT="${XH_COMMIT}" \
    TERM="xterm-256color"

COPY --from=config /etc/passwd /etc/passwd
COPY --from=builder /build/release/xh /usr/local/bin/xh

USER xh

ENTRYPOINT ["/usr/local/bin/xh"]
CMD ["--help"]

LABEL org.opencontainers.image.title="xh" \
    org.opencontainers.image.description="xh in a container" \
    org.opencontainers.image.revision="${XH_COMMIT}" \
    org.opencontainers.image.version="${XH_VERSION}"

