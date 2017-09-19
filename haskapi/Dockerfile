FROM haskell:8.0 as builder

MAINTAINER Guy John <guy@rumblesan.com>

RUN mkdir /opt/haskapi
WORKDIR /opt/haskapi

COPY haskapi.cabal haskapi.cabal
COPY stack.yaml stack.yaml

COPY app app
COPY test test

RUN stack test
RUN stack install --local-bin-path /opt/haskapi

FROM debian:jessie-slim

RUN apt-get update && apt-get install -y libgmp-dev && apt-get clean

RUN mkdir -p /opt/haskapi
WORKDIR /opt/haskapi

RUN /usr/sbin/useradd haskapi
RUN chown haskapi /opt/haskapi
USER haskapi

COPY --from=builder /opt/haskapi/haskapi .
CMD ["./haskapi"]  
