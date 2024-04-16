#! /usr/bin/env sh

set -eou

./buildconf --force

./configure --without-iconv --disable-phpdbg --with-zlib \
  --enable-opcache --disable-opcache-jit

make clean

./nb
