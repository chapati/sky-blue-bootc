# ==============================================================================
# Stage: Nushell Binary (Cached permanently until NU_VERSION changes)
# ==============================================================================
FROM registry.access.redhat.com/ubi10/ubi:latest AS nu-base

ARG NU_VERSION="0.115.0"
ARG NU_SHA256="da83cfe482060d2c34b6b9af829975a313bce6b92e0398c3b2a59cb38630c7b2"

RUN mkdir -p /build && \
    NU_FILE="nu-${NU_VERSION}-x86_64-unknown-linux-gnu" \
    && NU_URL="https://github.com/nushell/nushell/releases/download/${NU_VERSION}/${NU_FILE}.tar.gz" \
    && curl -sSL "${NU_URL}" -o "${NU_FILE}.tar.gz" \
    && echo "${NU_SHA256}  ${NU_FILE}.tar.gz" | sha256sum -c - \
    && tar -xzf "${NU_FILE}.tar.gz" \
    && mv "${NU_FILE}" /build/nu-shell \
    && rm "${NU_FILE}.tar.gz"

# =============================================================================
# Stage: Compile GTK Theme. Cached based on THEME_COMMIT
# =============================================================================
FROM alpine:latest AS theme-builder

# Tooling layer is cached until alpine version is changed
RUN apk add --no-cache bash git sassc glib

# Base repo layer, cached forever
WORKDIR /build/theme
RUN git init \
    && git remote add origin https://github.com/chapati/graphite-gtk-theme.git

# Commit-dependent layer
ARG THEME_COMMIT=main
RUN git fetch --depth 1 origin "${THEME_COMMIT}" \
    && git checkout FETCH_HEAD \
    && ./parse-sass.sh \
    && ./install.sh -d /tmp/themes -c dark --tweaks ayu normal rimless macos -t blue

# ==============================================================================
# Stage: Stable pre-build & post-build layer
# ==============================================================================
FROM nu-base AS ctx-prepost

RUN --mount=type=bind,target=/ctx \
    mkdir -p /build/ /build/lib/ && \
    cp -a /ctx/build/lib/. /build/lib/ && \
    cp /ctx/build/config.nu /build/ && \
    cp /ctx/build/pre-build.nu /build/ && \
    cp /ctx/build/post-build.nu /build/


# ==============================================================================
# Stage: Stable base layer
# ==============================================================================
FROM nu-base AS ctx-stable

WORKDIR /build

COPY build/   ./
COPY modules/ ./modules/
COPY recipes/ ./recipes/
COPY files/   ./files/


# ==============================================================================
# Stage: dev layer
# ==============================================================================
FROM nu-base AS ctx-dev

WORKDIR /build

COPY build/       ./
COPY modules/     ./modules/
COPY dev/modules/ ./modules/
COPY dev/recipes/ ./recipes/
COPY dev/files/   ./files/

#
# Base Image
#
FROM ghcr.io/ublue-os/bluefin-nvidia-open:stable

# Copy compiled theme from the theme-builder
COPY --from=theme-builder /tmp/themes/ /usr/share/themes/

ARG OPTFIX_DIR="/usr/lib/opt"
### [IM]MUTABLE /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

#
# Run declarative build yamls
#
RUN --mount=type=bind,from=ctx-prepost,source=/build,target=/build \
    /build/nu-shell/nu --config /build/config.nu /build/pre-build.nu --optfix "${OPTFIX_DIR}"

#
# Run stable layer
#
ARG IMAGE_NAME
ARG IMAGE_FLAVOR
ARG IMAGE_VENDOR
ARG IMAGE_TAG
ARG BASE_IMAGE_NAME

RUN --mount=type=bind,from=ctx-stable,source=/build,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    echo "==> Production Build: Validating required build args..." && \
    [ -n "$IMAGE_NAME" ]      || { echo "FATAL: IMAGE_NAME build arg is missing"; exit 1; } && \
    [ -n "$IMAGE_FLAVOR" ]    || { echo "FATAL: IMAGE_FLAVOR build arg is missing"; exit 1; } && \
    [ -n "$IMAGE_VENDOR" ]    || { echo "FATAL: IMAGE_VENDOR build arg is missing"; exit 1; } && \
    [ -n "$IMAGE_TAG" ]       || { echo "FATAL: IMAGE_TAG build arg is missing"; exit 1; } && \
    [ -n "$BASE_IMAGE_NAME" ] || { echo "FATAL: BASE_IMAGE_NAME build arg is missing"; exit 1; } && \
    export IMAGE_NAME IMAGE_FLAVOR IMAGE_VENDOR IMAGE_TAG BASE_IMAGE_NAME && \
    /build/nu-shell/nu --config /build/config.nu /build/build.nu --recipe /build/recipes/sky-blue.yaml --base /build && \
    dnf -y autoremove && \
    dconf update

#
# Run dev layer, by default it is skipped
#
ARG SKIP_DEV_LAYER="true"
RUN --mount=type=bind,from=ctx-dev,source=/build,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    if [ "$SKIP_DEV_LAYER" != "true" ]; then \
        echo "==> Dev Build: Validating required build args..." && \
        [ -n "$IMAGE_NAME" ]      || { echo "FATAL: IMAGE_NAME build arg is missing"; exit 1; } && \
        [ -n "$IMAGE_FLAVOR" ]    || { echo "FATAL: IMAGE_FLAVOR build arg is missing"; exit 1; } && \
        [ -n "$IMAGE_VENDOR" ]    || { echo "FATAL: IMAGE_VENDOR build arg is missing"; exit 1; } && \
        [ -n "$IMAGE_TAG" ]       || { echo "FATAL: IMAGE_TAG build arg is missing"; exit 1; } && \
        [ -n "$BASE_IMAGE_NAME" ] || { echo "FATAL: BASE_IMAGE_NAME build arg is missing"; exit 1; } && \
        export IMAGE_NAME IMAGE_FLAVOR IMAGE_VENDOR IMAGE_TAG BASE_IMAGE_NAME && \
        DEV_MODE=true /build/nu-shell/nu --config /build/config.nu /build/build.nu --recipe /build/recipes/dev-blue.yaml --base /build && \
        dnf -y autoremove && \
        dconf update ; \
    else \
        echo "Skipping dev layer" ; \
    fi

# dnf clean all && \
# rm -rf /var/cache/dnf /var/cache/libdnf5 /var/lib/dnf/history.*

RUN --mount=type=bind,from=ctx-prepost,source=/build,target=/build \
    /build/nu-shell/nu --config /build/config.nu /build/post-build.nu --optfix "${OPTFIX_DIR}"

#
# Verify final image and contents are correct.
#
RUN bootc container lint
