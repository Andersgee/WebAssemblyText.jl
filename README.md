# WebAssemblyText.jl

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://andersgee.github.io/WebAssemblyText.jl/dev)
[![Build Status](https://travis-ci.com/andersgee/WebAssemblyText.jl.svg?branch=master)](https://travis-ci.com/andersgee/WebAssemblyText.jl)

Convert Julia to WebAssembly text.

```julia
@code_wat expr

jl2wat(path)

jlstring2wat(str)
```

## Example

```julia
julia> using WebAssemblyText
julia> hello(x) = 3.1*x
julia> @code_wat hello(1.2)
```

```wasm
(func $hello (export "hello") (param $x f32) (result f32)
(return (f32.mul (f32.const 3.1) (local.get $x))))
```

[Documentation](https://andersgee.github.io/WebAssemblyText.jl/dev/)
