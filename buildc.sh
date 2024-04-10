#! /usr/bin/env sh

set -eou

./buildconf --force

ZLIB_CFLAGS="-I../wasix-deps/include/zlib" \
ZLIB_LIBS="-L../wasix-deps/lib -lz" \
LIBXML_CFLAGS="-I../wasix-deps/include/libxml2" \
LIBXML_LIBS="-L../wasix-deps/lib -lxml2 -llzma" \
SQLITE_CFLAGS="-I../wasix-deps/include/sqlite" \
SQLITE_LIBS="-L../wasix-deps/lib -lsqlite3" \
OPENSSL_CFLAGS="-I../wasix-deps/include/openssl" \
OPENSSL_LIBS="-L../wasix-deps/lib -lssl -lcrypto" \
PHP_EXTRA_INCLUDES="" \
# CURL_CFLAGS="-I/Users/arshia/repos/wasmer/php/curl/include" \
# CURL_LIBS="-L/Users/arshia/repos/wasmer/php/curl/build/lib -lcurl" \
RANLIB=llvm-ranlib \
AR=llvm-ar \
NM=llvm-nm \
CC="clang-15 --target=wasm32-wasi --sysroot=/opt/wasix-sysroot" \
CXX="clang-15 --target=wasm32-wasi --sysroot=/opt/wasix-sysroot" \
CFLAGS="-matomics -mbulk-memory -mmutable-globals -pthread -mthread-model posix -ftls-model=local-exec \
  -fno-trapping-math -D_WASI_EMULATED_MMAN -D_WASI_EMULATED_SIGNAL -D_WASI_EMULATED_PROCESS_CLOCKS -g -flto \
  -I../wasix-deps/include/zlib -I../wasix-deps/include/sqlite \
  -I../wasix-deps/include/openssl -I../wasix-deps/include/libxml2 \
  -L../wasix-deps/lib -lz -lxml2 -llzma -lsqlite3 -lssl -lcrypto" \
LIBS="-Wl,--shared-memory -Wl,--max-memory=4294967296 -Wl,--import-memory -Wl,--export-dynamic \
  -Wl,--export=__heap_base -Wl,--export=__stack_pointer -Wl,--export=__data_end -Wl,--export=__wasm_init_tls \
  -Wl,--export=__wasm_signal -Wl,--export=__tls_size -Wl,--export=__tls_align -Wl,--export=__tls_base \
  -lwasi-emulated-mman -flto -g" \
./configure --enable-fd-setsize=32768 --enable-static --disable-shared --host=wasm32-wasi --target=wasm32-wasi \
  --enable-opcache --disable-opcache-jit --disable-huge-code-pages --disable-rpath --disable-cgi --with-curl=no --with-zlib \
  --without-openssl --disable-zend-signals --prefix=/Users/arshia/repos/wasmer/php/prefix \
  --with-valgrind=no --with-pcre-jit=no --without-iconv --disable-huge-code-pages --disable-phpdbg \
  --enable-fiber-asm --program-suffix=".wasm"

./build.sh
