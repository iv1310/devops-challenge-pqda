# Stage1: Builder
FROM debian:stable-slim AS builder

# Set Global Environment variables
ENV LITECOIN_VERSION=0.21.2.2
ENV LITECOIN_PGP_PUBKEY="3620E9D387E55666"
ENV LITECOIN_TARGET_PLATFORM=x86_64-linux-gnu

# Install required packages to download LITECOIN
RUN apt-get update -y && \
    apt-get install --no-install-recommends gnupg curl ca-certificates -y && \
    { \
        gpg --no-tty --keyserver pgp.mit.edu --recv-keys "${LITECOIN_PGP_PUBKEY}" || \
        gpg --no-tty --keyserver keyserver.pgp.com --recv-keys "${LITECOIN_PGP_PUBKEY}" || \
        gpg --no-tty --keyserver ha.pool.sks-keyservers.net --recv-keys "${LITECOIN_PGP_PUBKEY}" || \
        gpg --no-tty --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "${LITECOIN_PGP_PUBKEY}"; \
    } || echo "Intermittent error to add keyserver"

# Download LITECOIN release and verify checksum
RUN curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-${LITECOIN_TARGET_PLATFORM}.tar.gz && \
    curl -SLO https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/SHA256SUMS.asc && \
    { \
        gpg --verify SHA256SUMS.asc; \
    } || echo "Intermittent error while adding keyserver" && \
    grep $(sha256sum litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') SHA256SUMS.asc && \
    tar -xf *.tar.gz -C /tmp && \
    mv /tmp/litecoin-${LITECOIN_VERSION} /tmp/litecoin && \
    rm -rf *.tar.gz

# Stage2: Runtime
FROM gcr.io/distroless/cc-debian12:nonroot

LABEL maintainer="Ivan Simatupang (ivansmtg13@gmail.com)"

# Copy Litecoin from builder
COPY --from=builder /tmp/litecoin /usr/local/bin/litecoin

# Set workdir
WORKDIR /opt/litecoin

# Expose litecoin default ports
EXPOSE 9332 9333 19332 19333 19444

# Execute litecoin
CMD ["/usr/local/bin/litecoin/bin/litecoind", "-datadir=/opt/litecoin", "-printtoconsole"]
