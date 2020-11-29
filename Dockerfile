ARG TARGET_ARCH=amd64

## Supports x86_64, x86, armhf, arm64, ppc64le, armle
FROM ${TARGET_ARCH}/alpine:3.12

ARG ZEROTIER_VERSION
ARG BUILD_DATE

LABEL maintainer="Docker Containerized ZeroTier One Maintainers <leonardo_yu@hotmail.com>" \
    version="${ZEROTIER_VERSION}" \
    description="Docker Containerized ZeroTier One for use on Linux hosts." \
    org.label-schema.schema-version="1.0" \
    org.label-schema.name="zerotier" \
    org.label-schema.description="Docker Containerized ZeroTier One for use on Linux hosts." \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.url="https://zerotier.com" \
    org.label-schema.version="{$ZEROTIER_VERSION}" \
    org.label-schema.docker.cmd="docker run --device=/dev/net/tun \
    --net=host \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_ADMIN \
    --cap-add=CAP_SYS_RAWIO \
    -v /path/to/my-zerotier-one:/var/lib/zerotier-one \
    --name zerotier-one \
    -d lifeym/zerotier"

RUN set -x \
# add runtime dependences to world
    && apk add libstdc++ \
    && tempDir="$(mktemp -d)" \
# build and install
    && apk add --no-cache --virtual .build-deps \
        clang \
        make \
        linux-headers \
        alpine-sdk \
    && cd ${tempDir} \
    && wget "https://github.com/zerotier/ZeroTierOne/archive/$ZEROTIER_VERSION.tar.gz" \
    && tar xzvf "$ZEROTIER_VERSION.tar.gz" \
    && cd "ZeroTierOne-$ZEROTIER_VERSION" \
    && make selftest \
    && make \
    && make install \
    && apk del .build-deps \
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi

VOLUME ["/var/lib/zerotier-one"]

CMD ["zerotier-one"]
