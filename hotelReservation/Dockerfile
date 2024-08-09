FROM debian:buster-slim

WORKDIR /workspace

COPY go.sum go.sum
COPY go.mod go.mod
COPY vendor/ vendor/

COPY cmd/ cmd/
COPY dialer/ dialer/
COPY registry/ registry/
COPY services/ services/
COPY tls/ tls/
COPY tracing/ tracing/
COPY tune/ tune/

COPY go/bin/* /go/bin/

COPY config.json config.json

RUN chmod +x /go/bin/*

# RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go install -ldflags="-s -w" -mod=vendor ./cmd/...

ENV PATH="/go/bin:${PATH}"
