#! /usr/bin/env sh

set -eo

wasmer run sapi/cli/php.wasm \
  --llvm \
  --net \
  --volume ../wordpress:/app \
  --volume ../php-wasix-deps/openssl/ssl:/etc/ssl \
  --volume ../php-wasix-deps/icu:/icu \
  --env SSL_CERT_DIR=/etc/ssl/certs \
  --env OPENSSL_CONF=/etc/ssl/openssl.cnf \
  --use amin/bash \
  --forward-host-env \
  -- \
  -S localhost:8080 \
  -t /app \
  -d upload_max_filesize=128M \
  -d post_max_size=128M \
  -d max_input_vars=6144 \
  -d memory_limit=512M
