#
FROM debian:stable-slim AS base

##################################################

FROM base AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt-get install -y git vim build-essential cmake python3

RUN git clone https://github.com/ptitSeb/box86

RUN dpkg --add-architecture armhf && apt-get update
RUN apt-get install -y gcc-arm-linux-gnueabihf libc6:armhf

## Raspberry Pi 4,5 (32-Bit)
#RUN cmake .. -DRPI4=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo

WORKDIR /box86/build

## Raspberry Pi 4, 5 (64-Bit)
#RUN cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
#RUN cmake .. -DARM_DYNAREC=ON -DRK3399=1 -DCMAKE_BUILD_TYPE=RelWIthDebInfo
RUN cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo # -DRPI4ARM64=1 for Pi4 aarch64 (use `-DRPI3ARM64=1` for a PI3 model)

## Raspberry pi 3
# RUN cmake .. -DRPI3=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo

## Raspberry Pi 2
# RUN cmake .. -DRPI2=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo

RUN make -j$(nproc)
RUN make install
RUN rm -rf /box86
WORKDIR /

############################################

FROM builder AS finalize

## Clean up stuff
RUN apt-get update; apt-get -y --autoremove purge vim git build-essential cmake python3; apt-get -y clean; apt-get -y autoclean; rm -rf /var/lib/apt/lists/*

FROM scratch

COPY --from=finalize / /



