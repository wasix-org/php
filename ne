#! /usr/bin/env sh

set -eou

./sapi/cli/php \
  -t ../wordpress-wasmer-starter/app \
  -S localhost:8080 \
  -d opcache.enable_cli=1 \
  -d opcache.enable=1
