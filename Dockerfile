FROM alpine:3.12.0 as builder

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    cmake \
    bison \
    flex \
    cmake \
    pkgconfig

RUN git clone --depth 1 https://github.com/verilog-to-routing/vtr-verilog-to-routing.git /vtr

WORKDIR /vtr/

RUN make
RUN PREFIX=/opt/vtr/ make install

