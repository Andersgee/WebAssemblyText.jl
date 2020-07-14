# WebAssemblyText.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://andersgee.github.io/WebAssemblyText.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://andersgee.github.io/WebAssemblyText.jl/dev)
[![Build Status](https://travis-ci.com/andersgee/WebAssemblyText.jl.svg?branch=master)](https://travis-ci.com/andersgee/WebAssemblyText.jl)

Convert Julia to WebAssembly text format (Work in progress).

```julia
jl2wat(path)
jlstring2wat(str)
```

## Example

```julia
julia> using WebAssemblyText
julia> str="""

hello(x) = 2.0*x
hello(1.0)

""";
julia> wat = jlstring2wat(str);
julia> println(wat)
```

```wat
(module
(func $hello (export "hello") (param $x f32) (result f32)
( return ( f32.mul (f32.const 2.0) (local.get $x) ) ))
)
```

See [Documentation](https://andersgee.github.io/WebAssemblyText.jl/dev/).
