#! /usr/bin/env sh

set -eou

make -j16

# Some wasm-opt passes are not compatible with EH.
# When generating debug info, we don't need to disable them but without debug info we do, otherwise wasm-opt crashes.
# The offending passes are flatten, dae-optimizing and inlining-optimizing.

# First asyncify while preserving debug info
# O4 is only here for good measure, the important part is asyncify
wasm-opt -g \
  -O4 \
  --no-validation \
  --all-features \
  --disable-gc \
  --closed-world \
  --skip-pass=flatten \
  --skip-pass=dae-optimizing \
  --skip-pass=inlining-optimizing \
  --asyncify \
  --pass-arg=asyncify-imports@wasix_32v1.proc_snapshot \
  --pass-arg=asyncify-ignore-indirect \
  --pass-arg=max-func-params@32 \
  sapi/cli/php -o sapi/cli/php-debug.wasm

# A second wasm-opt run for stripping debug 
# info and running full O4
wasm-opt --strip-debug \
  -O4 \
  --no-validation \
  --all-features \
  --disable-gc \
  --closed-world \
  --skip-pass=flatten \
  --skip-pass=dae-optimizing \
  --skip-pass=inlining-optimizing \
  sapi/cli/php-debug.wasm -o sapi/cli/php.wasm