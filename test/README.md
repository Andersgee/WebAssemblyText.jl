test the file jl/hello.jl (which requires wat2wasm, wasm-opt and deno):

```bash
./compile.sh hello && ./test.sh hello
```

if only writing tests (which requires deno):

```bash
./test.sh hello
```
