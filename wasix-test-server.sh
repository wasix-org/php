#! /usr/bin/env sh

set -eux

wasmer run ./sapi/cli/php.wasm \
  --llvm \
  --net \
  --mapdir /app:./wasix-tests \
  --mapdir /etc/ssl:../php-wasix-deps/openssl/ssl \
  --env MYSQL_HOST=localhost \
  --env MYSQL_USERNAME=root \
  --env MYSQL_PASSWORD=passwd \
  --env PGSQL_HOST=localhost \
  --env PGSQL_USERNAME=postgres \
  --env PGSQL_PASSWORD=passwd \
  -- \
  -S localhost:8080 \
  -t /app
