# docker-postfix

A simple send-only SMTP postfix implementation. Designed for local development or as a sidecar.

## Usage

Inside a `docker-compose.yaml`

```yaml
mail:
    image: saracen9/postfix
    container_name: mail
    hostname: mail.mydomain.xyz
    restart: always
    networks:
      - internal_service
    environment:
      - POSTFIX_HOSTNAME=mail.mydomain.xyz
    ports:
      - "587"
```

From the terminal

```zsh
docker run \
  --name mail \
  --hostname mail.mydomain.xyz \
  -e POSTFIX_HOSTNAME=mail.mydomain.xyz \
saracen9/postfix
```

You can now point your services at this container, port `587` and send email via SMTP.
