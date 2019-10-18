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
RUN svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_400/final /llvm/llvm-4/source/tools/clang
RUN svn co https://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_400/final/ /llvm/llvm-4/source/projects/compiler-rt
RUN svn co https://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_400/final/ /llvm/llvm-4/source/projects/libcxx
RUN svn co https://llvm.org/svn/llvm-project/libcxxabi/tags/RELEASE_400/final/ /llvm/llvm-4/source/projects/libcxxabi
RUN mkdir -p /llvm/build; cd /llvm/build;
RUN cmake -G "Ninja" \
          -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
          -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" \
          -DLLVM_BINUTILS_INCDIR=/usr/include /llvm/llvm-4
RUN ninja install
