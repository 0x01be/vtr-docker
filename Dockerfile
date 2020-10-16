FROM 0x01be/vtr:build as build

FROM alpine

COPY --from=build /opt/vtr/ /opt/vtr/

RUN apk add --no-cache --virtual vtr-runtime-dependencies \
    libstdc++ \
    zlib

RUN adduser -D -u 1000 vtr

WORKDIR /vtr

RUN chown vtr:vtr /workspace

USER vtr

ENV PATH ${PATH}:/opt/vtr/bin/

