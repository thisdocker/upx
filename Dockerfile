# multi-stage builds require: Docker v17.05+

# https://github.com/upx/upx

FROM wuyumin/base AS buildStage

ARG UPX_VERSION=3.95

ENV LDFLAGS=-static

RUN apk update && apk upgrade \
  && apk add build-base bash perl-dev ucl-dev zlib-dev \
  && wget https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-src.tar.xz \
  && tar -Jxf upx-${UPX_VERSION}-src.tar.xz \
  && cd upx-${UPX_VERSION}-src/ \
  && make -C src all \
  && cp ./src/upx.out /usr/bin/upx \
  && ./src/upx.out /usr/bin/upx





FROM wuyumin/base

LABEL maintainer="Yumin Wu"

RUN apk update && apk upgrade \
  && apk add bash \
  && rm -rf /var/cache/apk/* /tmp/*

COPY --from=buildStage /usr/bin/upx /usr/bin/upx

CMD ["/bin/bash","-l"]
