FROM registry.access.redhat.com/ubi10/ubi AS ctx

RUN mkdir -p /build

ARG NU_VERSION="0.109.1"
RUN NU_FILE="nu-${NU_VERSION}-x86_64-unknown-linux-gnu" \
    && NU_URL="https://github.com/nushell/nushell/releases/download/${NU_VERSION}/${NU_FILE}.tar.gz" \
    && curl -L "${NU_URL}" | tar xz \
    && mv "${NU_FILE}" /build/nu-shell

COPY build /build
COPY recipes /build/recipes
COPY modules /build/modules

# Base Image
FROM ghcr.io/ublue-os/bluefin-nvidia-open:stable

### [IM]MUTABLE /opt
## Some bootable images, like Fedora, have /opt symlinked to /var/opt, in order to
## make it mutable/writable for users. However, some packages write files to this directory,
## thus its contents might be wiped out when bootc deploys an image, making it troublesome for
## some packages. Eg, google-chrome, docker-desktop.
##
## Uncomment the following line if one desires to make /opt immutable and be able to be used
## by the package manager.

# RUN rm /opt && mkdir /opt

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.
RUN --mount=type=bind,from=ctx,source=/build,target=/build \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /build/nu-shell/nu --config /build/config.nu /build/build.nu --recipe /build/recipes/sky-blue.yaml --modules /build/modules
    
RUN --mount=type=bind,from=ctx,source=/build,target=/build \
    /build/nu-shell/nu --config /build/config.nu /build/cleanup.nu

## Verify final image and contents are correct.
RUN bootc container lint
