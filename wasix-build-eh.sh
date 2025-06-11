#! /usr/bin/env sh

set -eou

make -j16

wasm-opt -O3 \
  --emit-exnref \
  --no-validation \
  --all-features \
  --strip-debug \
  --asyncify \
  --pass-arg=asyncify-imports@wasix_32v1.proc_snapshot \
  --pass-arg=asyncify-ignore-indirect \
  --pass-arg=max-func-params@32 \
  --fpcast-emu \
  sapi/cli/php -o sapi/cli/php.wasm
