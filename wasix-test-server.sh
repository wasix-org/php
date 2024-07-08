#! /usr/bin/env sh

set -eou

~/repos/wasmer/wasmer/target/release/wasmer run ./sapi/cli/php.wasm \
  --singlepass \
  --net \
  --mapdir /app:./wasix-tests \
  --mapdir /openssl:../php-wasix-deps/openssl \
  --env MYSQL_HOST=localhost \
  --env MYSQL_USERNAME=root \
  --env MYSQL_PASSWORD=passwd \
  --env PGSQL_HOST=localhost \
  --env PGSQL_USERNAME=postgres \
  --env PGSQL_PASSWORD=passwd \
  -- \
  -S localhost:8080 \
  -t /app
