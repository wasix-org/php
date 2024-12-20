#! /usr/bin/env sh

set -eou

wasmer run sapi/cli/php.wasm \
  --singlepass \
  --net \
  --mapdir /app:../wordpress-wasmer-starter \
  --mapdir /etc/ssl:../php-wasix-deps/openssl/ssl \
  --mapdir /icu:../php-wasix-deps/icu \
  --env SSL_CERT_DIR=/etc/ssl/certs \
  --env PHP_CLI_SERVER_WORKERS=3 \
  -- \
  -S localhost:8080 \
  -t /app/app \
  -d smtp_port=587 \
  -d SMTP=sandbox.smtp.mailtrap.io \
  -d sendmail_from=someone@example.com \
  -d sendmail_username=aaaaaaaaaaaaaa \
  -d sendmail_password=bbbbbbbbbbbbbb \
  -d upload_max_filesize=128M \
  -d post_max_size=128M \
  -d memory_limit=512M

