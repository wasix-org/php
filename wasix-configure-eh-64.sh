#! /usr/bin/env sh

set -eu

export WASIX_64BIT_LONG_PATCH=yes
export WASIX_EXTRA_FLAGS="-flto"

./wasix-configure-eh.sh
