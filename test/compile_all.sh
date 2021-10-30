#!/bin/bash
source "/home/andy/.bash_aliases"
shopt -s expand_aliases

#compile all .jl files in ./jl folder
#put .wat in ./wat folder
#put .wasm in ./wasm folder
for path in jl/*.jl; do
  filename="${path##*/}" #without folder path
  name="${filename%%.jl}" #without extension

  echo "Compiling jl/${name}.jl -> wat/${name}.wat -> wasm/${name}.wasm"
  
  julia jl2wat.jl jl/${name}.jl wat/${name}.wat
  wat2wasm wat/${name}.wat -o wasm/${name}.wasm
  wasm-opt --enable-multivalue -O4 wasm/${name}.wasm -o wasm/${name}.wasm #optimize -O4 aswell
done