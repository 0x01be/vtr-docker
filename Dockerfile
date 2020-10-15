FROM alpine as build

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    cmake \
    bison \
    flex \
    cmake \
    pkgconfig \
    zlib-dev \
    linux-headers

#ENV CFLAGGS "$CFLAGS -U_FORTIFY_SOURCE"
#ENV CXXFLAGS "$CXXFLAGS -U_FORTIFY_SOURCE"
ENV VTR_REVISION master
RUN git clone --depth 1 --branch ${VTR_REVISION} https://github.com/SymbiFlow/vtr-verilog-to-routing.git /vtr

WORKDIR /vtr

RUN make
RUN PREFIX=/opt/vtr/ make install

