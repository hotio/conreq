FROM ghcr.io/hotio/base@sha256:411bf1c3c08e452c2c8692ddde636b0099fbd3cead53846c096a5014fd57f908

EXPOSE 8000

ARG CRYPTOGRAPHY_DONT_BUILD_RUST=true

RUN apk add --no-cache python3 py3-pip sqlite-libs libstdc++ freetype libjpeg-turbo lcms2 openjpeg tiff zlib

ARG REQ_VERSION
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
    curl -fsSL "https://raw.githubusercontent.com/archmonger/conreq/${REQ_VERSION}/requirements.txt" > "${APP_DIR}/requirements.txt" && \
    pip3 install --no-cache-dir --upgrade -r "${APP_DIR}/requirements.txt" && \
    apk del --purge build-dependencies

ARG VERSION
RUN curl -fsSL "https://github.com/archmonger/conreq/archive/${VERSION}.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /
