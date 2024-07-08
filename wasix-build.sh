#! /usr/bin/env sh

set -eou

make -j14

wasm-opt -O3 --asyncify -g sapi/cli/php -o sapi/cli/php.wasm -pa max-func-params@32
