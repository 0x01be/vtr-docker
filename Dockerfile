FROM 0x01be/vtr:build as build

FROM 0x01be/xpra

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

COPY --from=build /opt/vtr/ /opt/vtr/
COPY --from=build /vtr/vtr_flow/* ${WORKSPACE}/flow/
RUN chown -R ${USER}:${USER} ${WORKSPACE}

USER ${USER}

ENV VTR_ROOT /opt/vtr/
ENV PATH ${PATH}:/opt/vtr/bin/
ENV COMMAND "vpr ${WORKSPACE}/flow/timing/EArch.xml ${WORKSPACE}/flow/blif/tseng.blif --route_chan_width 100 --disp on"

