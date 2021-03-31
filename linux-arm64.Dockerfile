FROM ghcr.io/hotio/base@sha256:5f68a5ce9c8a2ebbcb8bab7c5d2953f1e6ac41784fad32b57652f36acd9a0ee2

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
