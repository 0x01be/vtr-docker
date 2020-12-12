FROM 0x01be/eigen as eigen

FROM 0x01be/base as build

COPY --from=eigen /opt/eigen/ /opt/eigen/

ENV REVISION=master \
    CFLAGGS="$CFLAGS -U_FORTIFY_SOURCE" \
    CXXFLAGS="$CXXFLAGS -U_FORTIFY_SOURCE" \
    C_INCLUDE_PATH=/usr/include/:/opt/eigen/include/ \
    CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}:/opt/eigen

RUN apk add --no-cache --virtual vtr-build-dependencies \
    git \
    build-base \
    cmake \
    bison \
    flex \
    cmake \
    python3-dev \
    py3-pip \
    cython \
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
    gtk+3.0-dev \
    libxml2-dev \
    libxslt-dev &&\
    apk add --no-cache --virtual vtr-edge-build-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    libtbb-dev &&\
    ln -s /usr/bin/python3 /usr/bin/python &&\
    pip install \
    black \
    prettytable \
    pylint \
    lxml &&\
    git clone --depth 1 --branch ${VTR_REVISION} https://github.com/SymbiFlow/vtr-verilog-to-routing.git /vtr

WORKDIR /vtr/build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/vtr \
    .. &&\
    make
RUN make install

