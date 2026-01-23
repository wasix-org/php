#! /usr/bin/env sh

set -eu

export WASIX_64BIT_LONG_PATCH=no
export WASIX_EXTRA_CONFIGURE_FLAGS="--enable-zts --enable-embed=static  --prefix=$(realpath ./install)"

./wasix-configure-eh.sh
