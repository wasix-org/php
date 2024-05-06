#! /usr/bin/env sh

set -eou

export \
  CC=clang
  CXX=clang
  CFLAGS="-rdynamic -fno-omit-frame-pointer -g"

./buildconf --force

./configure --without-iconv --disable-phpdbg --with-zlib \
  --enable-opcache --disable-opcache-jit

make clean

./nb
