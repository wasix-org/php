#! /usr/bin/env sh

set -eu

if [ -f Makefile ]; then
  make clean
fi

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
  PHP_BUILD_SYSTEM="clang(WASIX+WasmEH)" \
  PHP_EXTRA_INCLUDES="" \
  PHP_IPV6="yes" \
  RANLIB="wasixranlib" \
  AR="wasixar" \
  NM="wasixnm" \
  CC="wasixcc" \
  CXX="wasixcc++" \
  CFLAGS="-g -flto -O4 -Wno-incompatible-function-pointer-types -Wno-compare-distinct-pointer-types" \
  CXXFLAGS="-g -flto -O4 -Wno-incompatible-function-pointer-types -Wno-compare-distinct-pointer-types" \
  LIBS="-L$PHP_WASIX_DEPS/lib-eh --no-wasm-opt -g -flto -O4" \
  WASIXCC_INCLUDE_CPP_SYMBOLS="yes" \
  WASIXCC_WASM_EXCEPTIONS="yes" \
  PROG_SENDMAIL="/usr/bin/sendmail"

./buildconf --force

./configure --enable-fd-setsize=8192 --enable-static --disable-shared --host=wasm32-wasi --target=wasm32-wasi \
  --enable-opcache --disable-opcache-jit --disable-huge-code-pages --disable-rpath --disable-cgi --with-zlib \
  --with-openssl --enable-mbstring --enable-mbregex --disable-zend-signals --prefix=/usr/bin \
  --with-valgrind=no --with-pcre-jit=no --disable-huge-code-pages --disable-phpdbg \
  --enable-bcmath --enable-tidy --enable-gd --enable-exif --with-jpeg --with-freetype --with-webp \
  --enable-fiber-asm --with-curl --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-zip --with-sodium \
  --with-pgsql="$PHP_WASIX_DEPS"/pgsql-eh --with-pdo-pgsql="$PHP_WASIX_DEPS"/pgsql-eh --enable-intl \
  --with-pdo-sqlite --enable-ftp --enable-igbinary --with-imagick  --with-iconv="$PHP_WASIX_DEPS"/iconv-eh --enable-debug \
  --program-suffix=".wasm"

./wasix-build-eh.sh
