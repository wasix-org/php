#! /usr/bin/env sh

set -eou

make -j16

wasm-opt -O3 \
  --strip-debug \
  --asyncify \
  --pass-arg=max-func-params@32 \
  sapi/cli/php -o sapi/cli/php.wasm
