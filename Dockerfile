ARG TZ='Europe/London'
FROM alpine

ARG POSTFIX_HOSTNAME=mail.local
ENV POSTFIX_HOSTNAME=${POSTFIX_HOSTNAME}
ARG POSTFIX_DOMAIN
ENV POSTFIX_DOMAIN=${POSTFIX_DOMAIN}

RUN apk add --no-cache --update postfix cyrus-sasl ca-certificates bash && \
    apk add --no-cache --upgrade musl musl-utils && \
    apk add mailutils --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    # Clean up
    (rm "/tmp/"* 2>/dev/null || true) && (rm -rf /var/cache/apk/* 2>/dev/null || true)

# Create postfix folders
RUN mkdir -p /var/spool/postfix/pid && mkdir -p /etc/postfix

# Expose mail submission agent port
EXPOSE 587

# Set hostname and reconfigure Postfix on startup
ADD configs/postfix/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh
ENTRYPOINT ["startup.sh"]

# Start postfix in foreground mode
CMD ["postfix", "start-fg"]