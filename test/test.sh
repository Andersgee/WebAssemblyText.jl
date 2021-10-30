#!/bin/bash
source "/home/andy/.bash_aliases"
shopt -s expand_aliases

filename="$1"

deno test --allow-read deno-test/${filename}.test.js
#deno test --allow-read --allow-write --allow-net deno-test/${filename}.js

#run all tests in ./deno-test folder
#deno test --allow-read ./deno-test
