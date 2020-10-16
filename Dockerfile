FROM 0x01be/vtr:build as build

FROM alpine

COPY --from=build /opt/vtr/ /opt/vtr/

RUN apk add --no-cache --virtual vtr-runtime-dependencies \
    libstdc++ \
    zlib \
    gtk+3.0 \
    libx11 \
    libxft \
    cairo \
    fontconfig \
    freetype

RUN apk add --no-cache --virtual vtr-edge-runtime-dependencies \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    libtbb

RUN adduser -D -u 1000 vtr

WORKDIR /workspace

RUN chown vtr:vtr /workspace

USER vtr

ENV PATH ${PATH}:/opt/vtr/bin/

