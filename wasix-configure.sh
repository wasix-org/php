#! /usr/bin/env sh

set -eu

if [ -f Makefile ]; then
  make clean
fi

SYSROOT=${SYSROOT:-"/home/arshia/repos/wasmer/wasix-libc/sysroot32"}
PHP_WASIX_DEPS=${PHP_WASIX_DEPS:-"../php-wasix-deps"}

export \
  CURL_CFLAGS="-I$PHP_WASIX_DEPS/include/curl" \
  CURL_LIBS="-lcurl -lcrypto -lssl" \
  ZLIB_CFLAGS="-I$PHP_WASIX_DEPS/include/zlib" \
  ZLIB_LIBS="-lz" \
  LIBXML_CFLAGS="-I$PHP_WASIX_DEPS/include/libxml2" \
  LIBXML_LIBS="-lxml2 -llzma" \
  SQLITE_CFLAGS="-I$PHP_WASIX_DEPS/include/sqlite" \
  SQLITE_LIBS="-lsqlite3" \
  OPENSSL_CFLAGS="-I$PHP_WASIX_DEPS/include/openssl" \
  OPENSSL_LIBS="-lssl -lcrypto" \
  ICONV_CFLAGS="-I$PHP_WASIX_DEPS/include/iconv" \
  ICONV_LIBS="-liconv -lcharset -licrt" \
  ICU_CFLAGS="-I$PHP_WASIX_DEPS/include/icu -std=c11 -DU_DISABLE_VERSION_SUFFIX -DU_DISABLE_RENAMING" \
  ICU_CXXFLAGS="-I$PHP_WASIX_DEPS/include/icu -std=c++17 -DU_DISABLE_VERSION_SUFFIX -DU_DISABLE_RENAMING" \
  ICU_LIBS="-licudata -licui18n -licuio -licutu -licuuc" \
  PNG_CFLAGS="-I$PHP_WASIX_DEPS/include/png" \
  PNG_LIBS="-lpng" \
  JPEG_CFLAGS="-I$PHP_WASIX_DEPS/include/jpeg" \
  JPEG_LIBS="-ljpeg" \
  FREETYPE2_CFLAGS="-I$PHP_WASIX_DEPS/include/freetype" \
  FREETYPE2_LIBS="-lfreetype" \
  WEBP_CFLAGS="-I$PHP_WASIX_DEPS/include/webp" \
  WEBP_LIBS="-lwebp -lsharpyuv" \
  LIBZIP_CFLAGS="-I$PHP_WASIX_DEPS/include/libzip" \
  LIBZIP_LIBS="-lzip" \
  LIBSODIUM_CFLAGS="-I$PHP_WASIX_DEPS/include/libsodium" \
  LIBSODIUM_LIBS="-lsodium" \
  ONIG_CFLAGS="-I$PHP_WASIX_DEPS/include/oniguruma" \
  ONIG_LIBS="-lonig" \
  IM_IMAGEMAGICK_CFLAGS="-I$PHP_WASIX_DEPS/include/ImageMagick -DIM_MAGICKWAND_HEADER_STYLE_SEVEN -DMAGICKCORE_QUANTUM_DEPTH=16 -DMAGICKCORE_HDRI_ENABLE=1 -DMAGICKCORE_CHANNEL_MASK_DEPTH=32" \
  IM_IMAGEMAGICK_LIBS="-lMagickCore-7.Q16HDRI -lMagickWand-7.Q16HDRI -ltiff" \
  WASIX_SENDMAIL_LIBS="-lwasix_sendmail" \
  PHP_BUILD_SYSTEM="clang(WASIX)" \
  PHP_EXTRA_INCLUDES="" \
  PHP_IPV6="yes" \
  RANLIB=llvm-ranlib-20 \
  AR=llvm-ar-20 \
  NM=llvm-nm-20 \
  CC="clang-20 --target=wasm32-wasi --sysroot=$SYSROOT" \
  CXX="clang++-20 --target=wasm32-wasi --sysroot=$SYSROOT" \
  CFLAGS="-matomics -mbulk-memory -mmutable-globals -pthread -mthread-model posix -ftls-model=local-exec \
    -fno-trapping-math -D_WASI_EMULATED_MMAN -D_WASI_EMULATED_SIGNAL -D_WASI_EMULATED_PROCESS_CLOCKS \
    -g -flto -O2 -std=c11" \
  CXXFLAGS="-matomics -mbulk-memory -mmutable-globals -pthread -mthread-model posix -ftls-model=local-exec \
    -fno-trapping-math -D_WASI_EMULATED_MMAN -D_WASI_EMULATED_SIGNAL -D_WASI_EMULATED_PROCESS_CLOCKS \
    -g -flto -fno-exceptions -O2 -std=c++17" \
  LIBS="-Wl,--shared-memory -Wl,--max-memory=4294967296 -Wl,--import-memory -Wl,--export-dynamic \
    -Wl,--export=__heap_base -Wl,--export=__stack_pointer -Wl,--export=__data_end -Wl,--export=__wasm_init_tls \
    -Wl,--export=__wasm_signal -Wl,--export=__tls_size -Wl,--export=__tls_align -Wl,--export=__tls_base \
    -lwasi-emulated-mman -flto -g -Wl,-z,stack-size=8388608 -Wl,--error-limit=0 -L$PHP_WASIX_DEPS/lib -v --no-wasm-opt"

./buildconf --force

./configure --enable-fd-setsize=8192 --enable-static --disable-shared --host=wasm32-wasi --target=wasm32-wasi \
  --enable-opcache --disable-opcache-jit --disable-huge-code-pages --disable-rpath --disable-cgi --with-zlib \
  --with-openssl --enable-mbstring --enable-mbregex --disable-zend-signals --prefix=/usr/bin \
  --with-valgrind=no --with-pcre-jit=no --with-iconv --disable-huge-code-pages --disable-phpdbg \
  --enable-bcmath --enable-tidy --enable-gd --enable-exif --with-jpeg --with-freetype --with-webp \
  --enable-fiber-asm --with-curl --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-zip --with-sodium \
  --with-pgsql=$PHP_WASIX_DEPS/pgsql --with-pdo-pgsql=$PHP_WASIX_DEPS/pgsql --enable-intl \
  --with-pdo-sqlite --enable-ftp --enable-igbinary --with-imagick=$PHP_WASIX_DEPS/ImageMagick \
  --program-suffix=".wasm"

./wasix-build.sh
