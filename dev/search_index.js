var documenterSearchIndex = {"docs":
[{"location":"Internals/","page":"Internals","title":"Internals","text":"CurrentModule = WebAssemblyText","category":"page"},{"location":"Internals/#WebAssemblyText","page":"Internals","title":"WebAssemblyText","text":"","category":"section"},{"location":"Internals/","page":"Internals","title":"Internals","text":"","category":"page"},{"location":"Internals/","page":"Internals","title":"Internals","text":"Modules = [WebAssemblyText]","category":"page"},{"location":"Internals/#WebAssemblyText.builtinfuncs","page":"Internals","title":"WebAssemblyText.builtinfuncs","text":"builtinfuncs: a Dict with handwritten .wat of some julia builtins.\n\n\n\n\n\n","category":"constant"},{"location":"Internals/#WebAssemblyText.argtypes!-Tuple{Core.CodeInfo, Dict, Dict, Any}","page":"Internals","title":"WebAssemblyText.argtypes!","text":"argtypes!(ci::CodeInfo, argtypes::Dict, funcs::Dict, items::Array)\n\nInfer argtypes and update argtypes if items[1] is in funcs.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.blockinfo-Tuple{Array}","page":"Internals","title":"WebAssemblyText.blockinfo","text":"blockinfo(ssa::Array)\n\nInfer a tree of WebAssembly blocks from ssa and return a BlockInfo struct containing\n\na goto dict\na list of which blocks each ssa index is a child of.\n\nDetails\n\nWebAssembly control instructions (mainly) consist of\n\nblocks: block, loop\nbranching: br, br_if, return\n\nNotes concerning WebAssembly control instructions:\n\nWe do not have Phi nodes (a block can only have one parent)\nWe do not have gotos/jumps. We can only branch backwards/up the block tree.\nHowever, branching to a block continues at end of that block, which effectively is a forward jump (aka break)\nSpecial case: branching to a loop block continues at start of that block (aka continue)\nbranching is specified in terms of number of levels up (br 0 goes to current block, br 1 goes to parent block and so on. return is essentialy sugar for br MAX)\n\nSo the strategy is to infer a blocktree from arbitrary gotos, insert blocks and translate gotos to branching in terms of levels up the tree.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.blockparse-Tuple{String}","page":"Internals","title":"WebAssemblyText.blockparse","text":"blockparse(str::String)\n\nInitial Meta.parse() on entire input. return funcs and initialize Dicts of argtypes and imports.\n\nDetails:\n\nfuncs: a dict with function,expression as key,values\nargtypes: a dict with with function,argtypes as key,values\nimports: a dict with with function,importstring as key,values\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.codeinfo-Tuple{Any, Array}","page":"Internals","title":"WebAssemblyText.codeinfo","text":"codeinfo(func::Symbol, argtypes::Array)\n\nEssentially code_typed() with optimize=false\n\nDetails:\n\nNot optimizing gives a much simpler ast without phinodes and boundchecks.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.declaration-NTuple{4, Any}","page":"Internals","title":"WebAssemblyText.declaration","text":"declaration(cinfo, func, argtypes, Rtype)\n\nGet a wat string with function declaration.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.getbuiltins-Tuple{Array}","page":"Internals","title":"WebAssemblyText.getbuiltins","text":"getbuiltins(ssa::Array)\n\nGet an array of strings with any used builtin .wat functions as specified by the dict builtinfuncs.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.getimports-Tuple{Dict}","page":"Internals","title":"WebAssemblyText.getimports","text":"getimports(imports::Dict)\n\nGet a .wat string with any used functions that are not builtins or userdefined.\n\nDetails\n\na few basic are builtin to wasm. these can be translated.\nother basic functions are bultin to JavaScripts global Math object, these can be imported\nmany more are builtin to julia... so they need to be implemented either in .jl, .wat or .js\ngive warning if the function cant be imported from js Math.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.inlinessarefs-Tuple{Array}","page":"Internals","title":"WebAssemblyText.inlinessarefs","text":"inlinessarefs(ssa::Array)\n\nCopypaste ssa refs into place and delete used ssa refs. \n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.itemtype-Tuple{Core.CodeInfo, Any}","page":"Internals","title":"WebAssemblyText.itemtype","text":"itemtype(ci::CodeInfo, item)\n\nInfer a concrete DataType from item. Item might be slotnumber or ssavalue etc.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.jl2wat-Tuple{AbstractString}","page":"Internals","title":"WebAssemblyText.jl2wat","text":"jl2wat(path::AbstractString)\n\nConvert contents of a julia source code file to WebAssembly text.\n\nExamples\n\njulia> using WebAssemblyText\njulia> wat = jl2wat(\"example.jl\")\njulia> println(wat)\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.jlstring2wat-Tuple{AbstractString}","page":"Internals","title":"WebAssemblyText.jlstring2wat","text":"jlstring2wat(str::AbstractString)\n\nConvert a string of julia source code to WebAssembly text.\n\nExamples\n\njulia> using WebAssemblyText\njulia> str=\"\nhello(x) = 2.0*x\nhello(1.0)\n\";\njulia> wat = jlstring2wat(str);\njulia> println(wat)\n\n(module \n\n(func $hello (export \"hello\") (param $x f32) (result f32)\n( return ( f32.mul (f32.const 2.0) (local.get $x) ) ))\n)\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.jsimportentry-Tuple{Any, Any}","page":"Internals","title":"WebAssemblyText.jsimportentry","text":"jsimportentry(func, argtypes)\n\nGet a string of possible javascript Math module import, assuming it exists in the Math module.\n\nDetails\n\nfrom a func such as sin, return a string like \"sin: (x) => Math.sin(x)\"\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.process-NTuple{4, Any}","page":"Internals","title":"WebAssemblyText.process","text":"process(func, funcs, argtypes)\n\nGet a string with a self contained (func ) expression in .wat format\n\nDetails\n\nThe main steps of translating a single function\n\ntype infer func given argtypes[func]\nstructure ssa\nupdate argtypes for other functions called in this function\ntranslate to wat and inline to a string\nwrap string in a function declaration\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.restructure-Tuple{Core.CodeInfo, Integer, Array, Any}","page":"Internals","title":"WebAssemblyText.restructure","text":"restructure(ci::CodeInfo, i::Integer, ssa::Array, items::Array)\n\nRestructure items for more straightforward translation.\n\nDetails\n\nfor example, rewriting expressions like this:\n\n[mul,a,b,c,d] => [mul,d,[mul,c,[mul,a,b]]]\n[ifselse, cond, a, b] => [select, a, b, cond]\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.structure-Tuple{Array}","page":"Internals","title":"WebAssemblyText.structure","text":"structure(items)\n\nRecursively format expressions as lists: [operator, operands...]\n\nNotes:\n\nlist trees (aka S-expressions) are convenient to work with because modifying it with a recursive function is easy. Also, WebAssembly supports text format written in S-expressions so if all required functionality like overloading, phinodes and such was built into WebAssembly one could essentially do a one liner: webassemblytext = translate(structure(code_typed(somejuliafunction))\n\nDetails:\n\nExpressions dont always have the operator in head, sometimes its in args[1] and head is just :call\npi et al are refs, so if eval(item) is a number just use the number instead of the ref\nConst can hold anything inside it, use the value instead of the container\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.translate-Tuple{Integer, Core.CodeInfo, Any}","page":"Internals","title":"WebAssemblyText.translate","text":"translate(i::Integer, cinfo::CodeInfo, item)\n\nGet a wat string from item, specialized on item type.\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.translate-Tuple{Integer, Core.CodeInfo, Array}","page":"Internals","title":"WebAssemblyText.translate","text":"translate(ci::CodeInfo, items::Array)\n\nGet a wat string from items, branching to special cases based on items[1].\n\n\n\n\n\n","category":"method"},{"location":"Internals/#WebAssemblyText.@code_wat-Tuple{Any}","page":"Internals","title":"WebAssemblyText.@code_wat","text":"@code_wat expression\n\nMacro for translating a single function without adding on imports and builtins.\n\nExamples\n\njulia> hello(x) = 3.1*x\njulia> @code_wat hello(1.2)\n\n(func $hello (export \"hello\") (param $x f32) (result f32) \n(return (f32.mul (f32.const 3.1) (local.get $x))))\n\n\n\n\n\n","category":"macro"},{"location":"#Home","page":"Home","title":"Home","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"warning: Work in progress!\nThis documentation (and the entire package) is a work in progress.","category":"page"},{"location":"#Public-functions","page":"Home","title":"Public functions","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"jl2wat\njlstring2wat\n@code_wat","category":"page"},{"location":"#WebAssemblyText.jl2wat","page":"Home","title":"WebAssemblyText.jl2wat","text":"jl2wat(path::AbstractString)\n\nConvert contents of a julia source code file to WebAssembly text.\n\nExamples\n\njulia> using WebAssemblyText\njulia> wat = jl2wat(\"example.jl\")\njulia> println(wat)\n\n\n\n\n\n","category":"function"},{"location":"#WebAssemblyText.jlstring2wat","page":"Home","title":"WebAssemblyText.jlstring2wat","text":"jlstring2wat(str::AbstractString)\n\nConvert a string of julia source code to WebAssembly text.\n\nExamples\n\njulia> using WebAssemblyText\njulia> str=\"\nhello(x) = 2.0*x\nhello(1.0)\n\";\njulia> wat = jlstring2wat(str);\njulia> println(wat)\n\n(module \n\n(func $hello (export \"hello\") (param $x f32) (result f32)\n( return ( f32.mul (f32.const 2.0) (local.get $x) ) ))\n)\n\n\n\n\n\n","category":"function"},{"location":"#WebAssemblyText.@code_wat","page":"Home","title":"WebAssemblyText.@code_wat","text":"@code_wat expression\n\nMacro for translating a single function without adding on imports and builtins.\n\nExamples\n\njulia> hello(x) = 3.1*x\njulia> @code_wat hello(1.2)\n\n(func $hello (export \"hello\") (param $x f32) (result f32) \n(return (f32.mul (f32.const 3.1) (local.get $x))))\n\n\n\n\n\n","category":"macro"}]
}
