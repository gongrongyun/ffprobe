#! /bin/bash -x

EMSCRIPTEM_VERSION=3.1.33

docker pull emscripten/emsdk:${EMSCRIPTEM_VERSION}
docker run \
  --rm \
  -v $PWD:/src \
  -v $PWD/cache-wasm:/emsdk_portable/.data/cache/wasm \
  emscripten/emsdk:${EMSCRIPTEM_VERSION} \
  sh -c 'bash ./build.sh'