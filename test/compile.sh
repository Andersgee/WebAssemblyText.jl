#!/bin/bash
source "/home/andy/.bash_aliases"
shopt -s expand_aliases

filename="$1"
julia jl2wat.jl jl/${filename}.jl wat/${filename}.wat
wat2wasm wat/${filename}.wat -o wasm/${filename}.wasm
wasm-opt --enable-multivalue -O4 wasm/${filename}.wasm -o wasm/${filename}.wasm
