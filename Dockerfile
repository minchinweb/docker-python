# Base Image, now with Python!

ARG UBUNTU_VERSION=bionic
ARG PYTHON_VERSION=3.7.3

# these are provided by the build hook when run on Docker Hub
ARG BUILD_DATE="1970-01-01T00:00:00Z"
ARG COMMIT="local-build"
ARG URL="https://github.com/MinchinWeb/docker-python"
ARG BRANCH="none"

FROM python:${PYTHON_VERSION}-stretch as python-builder

FROM minchinweb/base:${UBUNTU_VERSION}

LABEL maintainer="MinchinWeb" \
      org.label-schema.description="Personal base image, now with Python!" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-url=${URL} \
      org.label-schema.vcs-ref=${COMMIT} \
      org.label-schema.schema-version="1.0.0-rc1"

# keep apt happy
ARG DEBIAN_FRONTEND=noninteractive

# copy pip config to remove local caching
COPY root/ /

# copy Python from official image
COPY --from=python-builder /usr/local /usr/local

# register Python .so files
WORKDIR /usr/local/lib
RUN ldconfig

RUN \
    apt update && \
    apt install -y \
            # needed for pip
            libexpat1 \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["python"]
