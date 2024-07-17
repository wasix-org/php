#! /usr/bin/env sh

set -eou

wasmer run sapi/cli/php.wasm \
  --singlepass \
  --net \
  --mapdir /app:../wordpress-wasmer-starter \
  --mapdir /openssl:../php-wasix-deps/openssl \
  --env SSL_CERT_DIR=/openssl/ssl/certs \
  -- \
  -S localhost:8080 \
  -t /app/app \
  -d smtp_port=587 \
  -d SMTP=sandbox.smtp.mailtrap.io \
  -d sendmail_from=someone@example.com \
  -d sendmail_username=aaaaaaaaaaaaaa \
  -d sendmail_password=bbbbbbbbbbbbbb

