FROM ubuntu:16.04
MAINTAINER Ridwan Shariffdeen <ridwan@comp.nus.edu.sg>

RUN apt-get update && apt-get install -y \
    autoconf \
    bison \
    binutils-dev \
    binutils-gold \
    cmake \
    curl \
    flex \
    git \
    google-perftools \
    libboost-all-dev \
    libgoogle-perftools-dev \
    libncurses5-dev \
    minisat \
    nano \
    ninja \
    perl \
    python2.7 \
    python-pip \
    software-properties-common \
    subversion \
    unzip \
    zlib1g-dev \
    wget

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add -
RUN mkdir -p /llvm/llvm-4; git clone http://llvm.org/git/llvm.git /llvm/llvm-4/source; cd /llvm/llvm-4/source; git checkout release_40
