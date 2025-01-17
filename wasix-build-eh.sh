#! /usr/bin/env sh

set -eou

make -j16

wasm-opt -O3 \
  --asyncify \
  --pass-arg=asyncify-imports@wasix_32v1.proc_snapshot \
  --pass-arg=asyncify-ignore-indirect \
  -pa max-func-params@32 \
  sapi/cli/php -o sapi/cli/php.wasm

wasm-strip sapi/cli/php.wasm