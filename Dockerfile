ARG BASE_IMAGE=ghcr.io/xtruder/kali-default:latest
FROM ${BASE_IMAGE}

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        kali-desktop-xfce xorg xrdp firefox-esr && \
    apt-get clean

COPY docker-entrypoint.sh /

EXPOSE 3389/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sleep", "infinity"]
