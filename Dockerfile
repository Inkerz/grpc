########################################################################################
#                               BUILDER IMAGE                                          #
########################################################################################
FROM public.ecr.aws/ubuntu/ubuntu:20.04 AS builder
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends cmake build-essential autoconf libtool pkg-config g++ gcc git ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

#Install gRPC
WORKDIR /
RUN git clone --recurse-submodules -b v1.51.1 https://github.com/grpc/grpc

WORKDIR /grpc/build
RUN cmake \
	-DCMAKE_BUILD_TYPE=Release \
	-DgRPC_INSTALL=ON \
	-DgRPC_BUILD_TESTS=OFF \
	-DCMAKE_INSTALL_PREFIX=/usr ..
RUN make -j10
RUN DESTDIR=/install make install

WORKDIR /artifacts
ENTRYPOINT tar -czvf grpc-1.51.1.tar.gz -C /install .

