function defaultImports() {
  return {
    memory: new WebAssembly.Memory({ initial: 1, maximum: 1 }), //default 1 page of memory. Call wasm.requiredpages() after storing data for appropriate number here.
    println: (x) => console.log(x),
    "^": (a, p) => Math.pow(a, p),
    rand: (a) => Math.random(a),
    atan2: (a, b) => Math.atan2(a, b),
    sin: (a) => Math.sin(a),
    cos: (a) => Math.cos(a),
    tan: (a) => Math.tan(a),
    asin: (a) => Math.asin(a),
    acos: (a) => Math.acos(a),
    atan: (a) => Math.atan(a),
    sinh: (a) => Math.sinh(a),
    cosh: (a) => Math.cosh(a),
    tanh: (a) => Math.tanh(a),
    asinh: (a) => Math.asinh(a),
    acosh: (a) => Math.acosh(a),
    atanh: (a) => Math.atanh(a),
    cbrt: (a) => Math.cbrt(a),
    exp: (a) => Math.exp(a),
    expm1: (a) => Math.expm1(a),
    log: (a) => Math.log(a),
    log1p: (a) => Math.log1p(a),
    log10: (a) => Math.log10(a),
    log2: (a) => Math.log2(a),
    sign: (a) => Math.sign(a),
  };
}

export default async function webassembly_deno(path) {
  const imports = defaultImports()

  const readWasm = await Deno.readFile(path);
  const bin = new Uint8Array(readWasm);
  const mod = new WebAssembly.Module(bin);
  const instance = new WebAssembly.Instance(mod, { imports });

  return amendexports(instance.exports, imports)
}

export default async function webassembly_http(url) {
  const imports = defaultImports()

  const mod = await WebAssembly.instantiateStreaming(fetch(url), {
      imports,
    });

  return amendexports(mod.instance.exports, imports)
}

export default async function amendexports(exports, imports) {
  const wasm = { ...exports };

  //mem and intmem are VIEWS referring to the actual buffer
  wasm.mem = new Float32Array(imports.memory.buffer);
  wasm.intmem = new Int32Array(imports.memory.buffer);
  wasm.allocate_init(); //keep first index to count used memory

  //utils
  wasm.store = (M, size = [M.length, 1]) => {
    let ptr = wasm.allocate(size[0], size[1]);
    wasm.setsize(ptr, size[0], size[1]);

    let N = size[0] * size[1];
    for (let i = 0; i < N; i++) {
      wasm.setlinearindex(ptr, M[i], i + 1);
    }
    return ptr;
  };

  wasm.view = (ptr) => {
    let N = wasm.length(ptr);
    return new Float32Array(wasm.mem.buffer, ptr + 8, N);
  };

  wasm.storeview = (M, size = [M.length, 1]) => {
    let ptr = wasm.store(M, size);
    let v = wasm.view(ptr);
    return [ptr, v];
  };
  /*
  wasm.copy = (ptr) => {
    return wasm.copy(ptr);
  };*/

  wasm.copyview = (ptr) => {
    let newptr = wasm.copy(ptr);
    let v = wasm.view(newptr);
    return [newptr, v];
  };

  return wasm;
}
