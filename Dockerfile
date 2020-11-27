#ARG BUILDER_ARCH=amd64
ARG TARGET_ARCH=amd64
ARG ZEROTIER_VERSION

ARG BUILD_DATE
LABEL maintainer="Docker Containerized ZeroTier One Maintainers <leonardo_yu@hotmail.com>"
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
    -v /var/lib/zerotier-one:/var/lib/zerotier-one \
    -n zerotier-one \
    -d lifeym/zerotier"

## Supports x86_64, x86, armhf, arm64, ppc64le, armle
FROM ${TARGET_ARCH}/alpine:3.12

RUN set -x \
# using alpine mirror for building in china
    && echo "https://mirrors.aliyun.com/alpine/v3.12/main/" | tee /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/v3.12/community/" | tee -a /etc/apk/repositories \
#    && apk update \
    && tempDir="$(mktemp -d)" \
    && apk add --no-cache --virtual .build-deps \
        git \
        clang \
        make \
        alpine-sdk \
    && cd ${tempDir} \
    && git clone --branch ${ZEROTIER_VERSION} https://github.com/zerotier/ZeroTierOne.git \
    && if [ ! -d ZeroTierOne ]; then rm ${result_path}trials; fi \
    && cd ZeroTierOne \
    && make \
    && make install \
    && apk del .build-deps \
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi

CMD ["/usr/sbin/zerotier-one"]
