FROM debian:stable-slim

WORKDIR /tmp

ARG MATLAB_RELEASE=R2022b

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install --no-install-recommends --yes \
    wget \
    unzip \
    ca-certificates \
    tini \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm \ 
    && chmod +x mpm \
    && ./mpm install --release=${MATLAB_RELEASE} --destination=/opt/matlab --products MATLAB \
    || (echo "MPM Installation Failure. See below for more information:" && cat /tmp/mathworks_root.log && false) \
    && rm -f mpm /tmp/mathworks_root.log \
    && ln -s /opt/matlab/bin/matlab /usr/local/bin/matlab
