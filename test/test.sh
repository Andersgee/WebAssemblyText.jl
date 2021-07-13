#!/bin/bash
source "/home/andy/.bash_aliases"
shopt -s expand_aliases

filename="$1"

deno test --allow-read --allow-write --allow-net deno-test/${filename}.js
