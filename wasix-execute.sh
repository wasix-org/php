#! /usr/bin/env sh

set -eou

~/repos/wasmer/wasmer/target/release/wasmer run sapi/cli/php.wasm \
  --singlepass \
  --net \
  --mapdir /app:../wordpress-wasmer-starter \
  --mapdir /openssl:../php-wasix-deps/openssl \
  -- \
  -S localhost:8080 \
  -t /app/app
