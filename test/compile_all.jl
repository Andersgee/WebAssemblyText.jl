using Pkg; Pkg.activate("../")
using WebAssemblyText

wat2wasm="/home/andy/programs/wabt/bin/wat2wasm"
wasmvalidate="/home/andy/programs/wabt/bin/wasm-validate"
wasmopt="/home/andy/programs/binaryen/bin/wasm-opt"

stripextension(filename) = filename[1:end-3]

filenames = readdir("./jl")
names = stripextension.(filenames)

for name in names
  printstyled("Compiling jl/$name.jl -> wat/$name.wat -> wasm/$name.wasm\n"; color=:yellow)
  outfile = "wat/$name.wat"

  wat = jl2wat("jl/$name.jl")
  open(outfile, "w") do io
    write(io, wat)
  end
  printstyled("...wat", color=:green)

  run(`$wat2wasm wat/$name.wat -o wasm/$name.wasm`)
  printstyled("...wasm", color=:green)
  run(`$wasmvalidate wasm/$name.wasm`)
  printstyled("...validated", color=:green)
  run(`$wasmopt --enable-multivalue -O4 wasm/$name.wasm -o wasm/$name.wasm`)
  printstyled("...optimized\n", color=:green)
end