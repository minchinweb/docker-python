# Base Image, now with Python!

ARG PYTHON_VERSION=3.7.4
ARG UBUNTU_VERSION=bionic

FROM python:${PYTHON_VERSION}-stretch as python-builder

FROM minchinweb/base:${UBUNTU_VERSION}

# keep apt happy
ARG DEBIAN_FRONTEND=noninteractive

# these are provided by the build hook when run on Docker Hub
ARG BUILD_DATE="1970-01-01T00:00:00Z"
ARG COMMIT="local-build"
ARG URL="https://github.com/MinchinWeb/docker-python"
ARG BRANCH="none"

LABEL maintainer="MinchinWeb" \
      org.label-schema.description="Personal base image, now with Python!" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-url=${URL} \
      org.label-schema.vcs-ref=${COMMIT} \
      org.label-schema.schema-version="1.0.0-rc1"

# copy pip config to remove local caching
COPY root/ /

# copy Python from official image
COPY --from=python-builder /usr/local /usr/local

# register Python .so files
WORKDIR /usr/local/lib
RUN ldconfig

RUN \
    echo "[*] apt update" && \
    apt -qq update && \
    echo "[*] apt isntall" && \
    apt -qq install -y \
            # needed for pip
            libexpat1 \
    && \
    echo "[*] cleanup from apt" && \
    rm -rf /var/lib/apt/lists/*

RUN python -m pip --version
RUN python -m pip install pip --upgrade

# store Python Version; used for image tagging
# ARG needs to be declared here, and above any FROM line
# https://github.com/moby/moby/issues/37345#issuecomment-400245466
ARG PYTHON_VERSION
ENV PYTHON_VERSION=${PYTHON_VERSION}

WORKDIR /app

CMD ["python"]
