FROM 0x01be/vtr:build as build

FROM 0x01be/xpra

COPY --from=build /opt/vtr/ /opt/vtr/

USER root

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

COPY --from=build /vtr/vtr_flow/* /workspace/
RUN chown -R xpra:xpra /workspace

USER xpra

WORKDIR /workspace

ENV VTR_ROOT /opt/vtr/
ENV PATH ${PATH}:${VTR_ROOT}/bin/
ENV COMMAND "vpr /workspace/timing/EArch.xml /workspace/blif/tseng.blif --route_chan_width 100 --disp on"

