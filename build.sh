set -eou

echo '########### Starting build ###########'

make clean

make -j14

wasm-opt -O2 --asyncify -g --fpcast-emu sapi/cli/php -o php.wasm -pa max-func-params@32

echo "Done!"
