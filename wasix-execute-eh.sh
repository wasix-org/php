#! /usr/bin/env sh

set -eo

wasmer run sapi/cli/php-eh.wasm \
  --llvm \
  --net \
  --mapdir /app:../wordpress \
  --mapdir /etc/ssl:../php-wasix-deps/openssl/ssl \
  --mapdir /icu:../php-wasix-deps/icu \
  --env SSL_CERT_DIR=/etc/ssl/certs \
  --env OPENSSL_CONF=/etc/ssl/openssl.cnf \
  --use amin/bash \
  --forward-host-env \
  -- \
  -S localhost:8080 \
  -t /app \
  -d smtp_port=587 \
  -d SMTP=sandbox.smtp.mailtrap.io \
  -d sendmail_from=someone@example.com \
  -d sendmail_username=aaaaaaaaaaaaaa \
  -d sendmail_password=bbbbbbbbbbbbbb \
  -d upload_max_filesize=128M \
  -d post_max_size=128M \
  -d max_input_vars=6144 \
  -d memory_limit=512M
