FROM alpine:3.12

LABEL maintainer="Yet another NGINX Docker Maintainers <leonardo_yu@hotmail.com>"

ENV NGINX_VERSION 1.18.0
#ENV NJS_VERSION   0.4.2
#ENV PKG_RELEASE   1

RUN set -x \
# using alpine mirror for building in china
    && echo "https://mirrors.aliyun.com/alpine/v3.12/main/" | tee /etc/apk/repositories \
    && echo "https://mirrors.aliyun.com/alpine/v3.12/community/" | tee -a /etc/apk/repositories \
#    && apk update \
# create nginx user/group first, to be consistent throughout docker variants
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx \
    && tempDir="$(mktemp -d)" \
#    && chown nobody:nobody $tempDir \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        libc-dev \
        make \
        openssl-dev \
        pcre-dev \
        zlib-dev \
        linux-headers \
        libxslt-dev \
        gd-dev \
        geoip-dev \
        perl-dev \
        libedit-dev \
        git \
        bash \
#        alpine-sdk \
#        findutils \
#    && su nobody -s /bin/sh -c " \
#        export HOME=${tempDir} \
        && cd ${tempDir} \
# dl nginx-$
        && wget -O nginx.tar.gz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
        && tar xzf nginx.tar.gz \
# dl 3party modules
        && git clone https://github.com/arut/nginx-dav-ext-module.git \
        && cd nginx-${NGINX_VERSION} \
        && ./configure \
# official original config
	        --prefix=/etc/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log \
            --pid-path=/var/run/nginx.pid \
            --lock-path=/var/run/nginx.lock \
            --http-client-body-temp-path=/var/cache/nginx/client_temp \
            --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
            --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
            --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
            --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
            --with-perl_modules_path=/usr/lib/perl5/vendor_perl \
            --user=nginx \
            --group=nginx \
            --with-compat \
            --with-file-aio \
            --with-threads \
            --with-http_addition_module \
            --with-http_auth_request_module \
            --with-http_dav_module \
            --with-http_flv_module \
            --with-http_gunzip_module \
            --with-http_gzip_static_module \
            --with-http_mp4_module \
            --with-http_random_index_module \
            --with-http_realip_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-http_ssl_module \
            --with-http_stub_status_module \
            --with-http_sub_module \
            --with-http_v2_module \
            --with-mail \
            --with-mail_ssl_module \
            --with-stream \
            --with-stream_realip_module \
            --with-stream_ssl_module \
            --with-stream_ssl_preread_module \
            --with-cc-opt='-Os -fomit-frame-pointer' \
            --with-ld-opt=-Wl,--as-needed \
# add 3party modules
            --add-module=${tempDir}/nginx-dav-ext-module \
        && make \
#        " \
    && make install \
    && apk del .build-deps \
    && if [ -n "$tempDir" ]; then rm -rf "$tempDir"; fi \
# Bring in gettext so we can get `envsubst`, then throw
# the rest away. To do this, we need to install `gettext`
# then move `envsubst` out of the way so `gettext` can
# be deleted completely, then move `envsubst` back.
    && apk add --no-cache --virtual .gettext gettext \
    && mv /usr/bin/envsubst /tmp/ \
    && runDeps="$( \
        scanelf --needed --nobanner /tmp/envsubst \
            | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
            | sort -u \
            | xargs -r apk info --installed \
            | sort -u \
    )" \
    && apk add --no-cache $runDeps \
    && apk del .gettext \
    && mv /tmp/envsubst /usr/local/bin/ \
# Bring in tzdata so users could set the timezones through the environment
# variables
    && apk add --no-cache tzdata \
# forward request and error logs to docker log collector
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
# create a docker-entrypoint.d directory
    && mkdir /docker-entrypoint.d

#COPY docker-entrypoint.sh /
#COPY 10-listen-on-ipv6-by-default.sh /docker-entrypoint.d
#COPY 20-envsubst-on-templates.sh /docker-entrypoint.d
#ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
