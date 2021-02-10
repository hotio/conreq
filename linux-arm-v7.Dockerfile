FROM ghcr.io/hotio/base@sha256:d467e7bab4178ba8a2a635b510ccc76cf73fef193c3e86026c334071eaca2886

EXPOSE 8000

RUN apk add --no-cache python3 py3-pip sqlite-libs libstdc++ freetype libjpeg-turbo lcms2 openjpeg tiff zlib

ARG VERSION
RUN curl -fsSL "https://github.com/archmonger/conreq/archive/${VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

ARG CRYPTOGRAPHY_DONT_BUILD_RUST=true
RUN apk add --no-cache --virtual=build-dependencies \
    freetype-dev \
    libjpeg-turbo-dev \
    lcms2-dev \
    openjpeg-dev \
    tiff-dev \
    zlib-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    python3-dev && \
    pip3 install --no-cache-dir --upgrade -r "${APP_DIR}/requirements.txt" && \
    apk del --purge build-dependencies

COPY root/ /
