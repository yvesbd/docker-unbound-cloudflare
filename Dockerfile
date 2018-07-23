# docker-unbound-cloudflare
# Label reference="adapted from https://github.com/qdm12/cloudflare-dns-server"

FROM yvesbd/docker-alpine-base

LABEL description="Runs a DNS server connected to the secured Cloudflare DNS server 1.1.1.1" 

EXPOSE 8053/udp

RUN apk add --update --no-cache -q --progress unbound && \
    rm -rf /etc/unbound/unbound.conf /var/cache/apk/*

COPY unbound.conf blocks-malicious.conf blocks.conf /etc/unbound/
HEALTHCHECK --interval=10m --timeout=3s --start-period=3s --retries=1 CMD ping -W 1 -w 2 google.com &> /dev/null || exit 1

ENTRYPOINT echo "nameserver 127.0.0.1" > /etc/resolv.conf && \
           echo "options ndots:0" >> /etc/resolv.conf && \
           chmod -R 777 /var/log/unbound && \
           unbound -d -v

CMD ["-v"]
