# Build the Go Binary.
FROM golang:1.24 AS build_authx
ENV CGO_ENABLED=0
ARG BUILD_REF

# Copy the source code into the container.
COPY . /service

# Build the service binary. We are doing this last since this will be different
# every time we run through this process.
WORKDIR /service/api/services/authx
RUN go build -ldflags "-X main.build=${BUILD_REF}"


# Run the Go Binary in Alpine.
FROM alpine:3.22
ARG BUILD_DATE
ARG BUILD_REF
RUN addgroup -g 10001 -S authx && \
    adduser -u 10001 -h /service -G authx -S authx
COPY --from=build_authx --chown=authx:authx /service/api/services/authx/authx /service/authx
WORKDIR /service
USER authx
CMD ["./authx"]

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="authx" \
      org.opencontainers.image.authors="Muhammad Saad <m.saad@hashx.tech>" \
      org.opencontainers.image.source="https://github.com/hashxltd/iFabric/tree/master/a/services/authx" \
      org.opencontainers.image.revision="${BUILD_REF}" \
      org.opencontainers.image.vendor="HashX Ltd."
