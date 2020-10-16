FROM alpine as build

RUN apk add --no-cache --virtual build-dependencies \
    git \
    build-base \
    cmake \
    bison \
    flex \
    cmake \
    python3-dev \
    py3-pip \
    perl \
    perl-list-moreutils \
    pkgconfig \
    zlib-dev \
    linux-headers \
    cairo-dev \
    freetype-dev \
    libxft-dev \
    libx11-dev \
    fontconfig-dev \
    gtk+3.0-dev

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip install \
    black \
    prettytable \
    pylint \
    lxml

COPY --from=eigen /opt/eigen/ /opt/eigen/

ENV VTR_REVISION master
RUN git clone --depth 1 --branch ${VTR_REVISION} https://github.com/SymbiFlow/vtr-verilog-to-routing.git /vtr

WORKDIR /vtr/build

ENV CFLAGGS "$CFLAGS -U_FORTIFY_SOURCE"
ENV CXXFLAGS "$CXXFLAGS -U_FORTIFY_SOURCE"
ENV C_INCLUDE_PATH /usr/include/::/opt/eigen/include/
ENV CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH}:/opt/eigen

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/vtr \
    ..
RUN make
RUN make install

