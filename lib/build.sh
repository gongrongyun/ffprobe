#! /bin/bash

emcc -v

SKIP=$1
INITIAL_MEMORY=52428800
CFLAGS="-O3"
LDFLAGS="-s INITIAL_MEMORY=$INITIAL_MEMORY"
INSTALL_DIR="./build"
INCLUDE_DIR="$INSTALL_DIR"/include
LIB_DIR="$INSTALL_DIR"/lib

if [ -z "$SKIP" ]; then

ARGS=(
  --target-os=none
  # --arch=x86_32

  --disable-x86asm
  --disable-protocols
  --disable-hwaccels
  --disable-filters
  --disable-inline-asm
  # --disable-stripping
  --disable-doc
  --disable-programs
  --disable-encoders
  --disable-muxers
  --disable-outdevs
  --disable-indevs
  --disable-postproc
  --disable-devices

  # --enable-cross-compile
  --enable-small
  --enable-protocol=file

  --extra-cflags="$CFLAGS"
  --extra-cxxflags="$CFLAGS"
  --extra-ldflags="$LDFLAGS"
  # --nm="$EMSDK/upstream/bin/llvm-nm -g"
  --ar=emar
  # --as=llvm-as
  --ranlib=emranlib
  --cc=emcc
  --cxx=em++
  # --objcc=emcc
  # --dep-cc=emcc

  --prefix="$PWD"/"$INSTALL_DIR"
)

echo "===emconfigure==="
emconfigure ./configure "${ARGS[@]}"

echo "===make==="
emmake make clean
emmake make -j10

fi

mkdir -p wasm/dist

EMCCARGS=(
  fftools/ffprobe.c fftools/cmdutils.c
  -I. 
  -I./fftools
  # -I"$INCLUDE_DIR" "$LIB_DIR"/libavdevice.a "$LIB_DIR"/libavfilter.a "$LIB_DIR"/libavformat.a "$LIB_DIR"/libavcodec.a "$LIB_DIR"/libswresample.a "$LIB_DIR"/libswscale.a "$LIB_DIR"/libavutil.a
  # -lm
  -Llibavcodec -Llibavdevice -Llibavfilter -Llibavformat -Llibavresample -Llibavutil -Llibpostproc -Llibswscale -Llibswresample
  -lavdevice -lavfilter -lavformat -lavcodec -lswresample -lswscale -lavutil  -lm
  # -Qunused-arguments
  -Os -Wl
  # -g
  # -s STRIP=1
  -s INVOKE_RUN=0
  -s ALLOW_TABLE_GROWTH=1
  -s ALLOW_MEMORY_GROWTH=1
  -s MODULARIZE=1
  -s EXPORT_NAME="CreateFFprobe"
  -s EXPORTED_FUNCTIONS="[_main, _malloc]"
  -s EXPORTED_RUNTIME_METHODS="[FS, ccall, cwrap, allocate, UTF8ToString, stringToUTF8, lengthBytesUTF8, stringToUTF32]"
  -s INITIAL_MEMORY="$INITIAL_MEMORY"
  -o wasm/dist/ffprobe-wasm.js
)

echo "===emcc==="
emcc "${EMCCARGS[@]}"