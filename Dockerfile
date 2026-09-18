FROM ghcr.io/tgdrive/teldrive:latest AS bin

FROM alpine:3.20
RUN apk add --no-cache ca-certificates tzdata
COPY --from=bin /teldrive /usr/local/bin/teldrive
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
