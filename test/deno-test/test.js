import { assertEquals } from "https://deno.land/std@0.88.0/testing/asserts.ts";
import webassembly from "./webassembly.js";

const wasm = await webassembly("wasm/test.wasm");

Deno.test("initial memory", () => {
  const total_allocated_bytes = wasm.intmem[0];
  const gold = 4; //keep first int32 (4 bytes) of memory to count used memory
  assertEquals(total_allocated_bytes, gold);
});

Deno.test("store", () => {
  let byteptr = wasm.store([1, 2, 3]);
  assertEquals(byteptr, 4);

  //index into f32/i32 arrays (mem and intmem) by 32bit pointers (aka doubleword)
  //instead of 8bit pointers (aka byte)
  let i = byteptr / 4;
  assertEquals([wasm.intmem[i], wasm.intmem[i + 1]], [3, 1]); //size (i32)
  assertEquals([wasm.mem[i + 2], wasm.mem[i + 3], wasm.mem[i + 4]], [1, 2, 3]); //content (f32)
});

Deno.test("view", () => {
  let byteptr = wasm.store([4, 5, 6]);
  let v = wasm.view(byteptr);
  assertEquals(v, [4, 5, 6]);
});

Deno.test("length", () => {
  let v = wasm.store([4, 5, 6]);
  let l = wasm.length(v);
  assertEquals(l, 3);

  let v2 = wasm.store([4, 5, 6, 7, 8, 9], [3, 2]);
  let l2 = wasm.length(v2);
  assertEquals(l2, 6);
});

Deno.test("size", () => {
  let v = wasm.store([4, 5, 6]);
  let l = wasm.size(v);
  assertEquals(l, [3, 1]);

  let v2 = wasm.store([4, 5, 6, 7, 8, 9], [3, 2]);
  let l2 = wasm.size(v2);
  assertEquals(l2, [3, 2]);
});

Deno.test("modify view", () => {
  let byteptr = wasm.store([7, 8, 9]);
  let v = wasm.view(byteptr);
  assertEquals(v, [7, 8, 9]);

  v[2] = 99;
  assertEquals(v, [7, 8, 99]);

  //check if the actual webassembly memory just changed via javascript
  let i = byteptr / 4;

  assertEquals([wasm.intmem[i], wasm.intmem[i + 1]], [3, 1]);
  assertEquals([wasm.mem[i + 2], wasm.mem[i + 3], wasm.mem[i + 4]], [7, 8, 99]);
});

Deno.test("copy", () => {
  let a = wasm.store([1, 2, 3, 4]);
  let b = wasm.copy(a);

  assertEquals(b - a, 24); //b is in a different place, exactly 20 bytes away, (2+4 numbers * 4bytes)
  assertEquals(wasm.view(a), [1, 2, 3, 4]);
  assertEquals(wasm.view(b), [1, 2, 3, 4]);
});

Deno.test("storeview", () => {
  let [v, v_view] = wasm.storeview([1, 2, 3]);
  assertEquals(v_view, [1, 2, 3]);
});

Deno.test("copyview", () => {
  let [v, v_view] = wasm.storeview([4, 5, 6]);
  let [v2, v2_view] = wasm.copyview(v);
  assertEquals(v2_view, [4, 5, 6]);

  assertEquals(v2 - v, 20); //new array (2+3) * 4 bytes away
  let i = v2 / 4;
  assertEquals([wasm.intmem[i], wasm.intmem[i + 1]], [3, 1]); //size is copied
  assertEquals([wasm.mem[i + 2], wasm.mem[i + 3], wasm.mem[i + 4]], [4, 5, 6]); //content is copied
});

Deno.test("--------------------", () => {
  console.log("end of builtin tests");
});

Deno.test("scalar addition", () => {
  const r = wasm.scalaradd(1.1, 2.4);
  const gold = 3.5;
  assertEquals(r, gold);
});

Deno.test("vector sum", () => {
  const v = wasm.store([1, 2, 3, 4]);
  const r = wasm.sum(v);

  const gold = 10;
  assertEquals(r, gold);
});

Deno.test("tuplereturn", () => {
  const [a, b] = wasm.tuplereturn(3.2);
  assertEquals(a, 3.8400001525878906);
  assertEquals(b, 4.159999847412109);
});

Deno.test("tuplecall", () => {
  const r = wasm.tuplecall(2.1);
  assertEquals(r, 2.5199999809265137);
});

// deno test --allow-read --allow-write --allow-net runtests.js
// deno run --allow-read --allow-write --allow-net --watch --unstable  runtests.js
