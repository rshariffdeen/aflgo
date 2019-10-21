FROM ubuntu:16.04
MAINTAINER Ridwan Shariffdeen <ridwan@comp.nus.edu.sg>

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
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
    ninja-build \
    perl \
    python2.7 \
    python-pip \
    software-properties-common \
    subversion \
    unzip \
    zlib1g-dev \
    wget

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key| apt-key add -
RUN mkdir -p /llvm/llvm-4;
RUN svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_400/final /llvm/llvm-4/source
RUN svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_400/final /llvm/llvm-4/source/tools/clang
RUN svn co https://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_400/final/ /llvm/llvm-4/source/projects/compiler-rt
RUN svn co https://llvm.org/svn/llvm-project/libcxx/tags/RELEASE_400/final/ /llvm/llvm-4/source/projects/libcxx
RUN svn co https://llvm.org/svn/llvm-project/libcxxabi/tags/RELEASE_400/final/ /llvm/llvm-4/source/projects/libcxxabi
RUN mkdir -p /llvm/llvm-4/build; cd /llvm/llvm-4/build;
RUN cmake -G "Ninja" \
          -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
          -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" \
          -DLLVM_BINUTILS_INCDIR=/usr/include /llvm/llvm-4/source
RUN ninja install

RUN mkdir -p /llvm/llvm-4/msan; cd /llvm/llvm-4/msan;
RUN cmake -G "Ninja" \
          -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ \
          -DLLVM_USE_SANITIZER=Memory -DCMAKE_INSTALL_PREFIX=/usr/msan/ \
          -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON \
          -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86" /llvm/llvm-4/source
RUN ninja cxx; ninja install-cxx

# install LLVMgold in bfd-plugins
RUN mkdir /usr/lib/bfd-plugins; cp /usr/local/lib/libLTO.so /usr/lib/bfd-plugins; cp /usr/local/lib/LLVMgold.so /usr/lib/bfd-plugins
RUN export LC_ALL=C
RUN apt-get update && apt install -y \
    libclang-4.0-dev \
    libtool-bin  \
    python-dev \
    python3 \
    python3-dev \
    python3-pip \
    python-bs4

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install networkx pydot pydotplus

# build AFLGo
RUN git clone https://github.com/rshariffdeen/aflgo.git /aflgo
RUN cd /aflgo; make clean all; cd llvm_mode; make clean all
RUN export AFLGO=/aflgo