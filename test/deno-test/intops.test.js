import webassembly from "./webassembly.js";
import { assertEquals } from "https://deno.land/std@0.88.0/testing/asserts.ts";

const wasm = await webassembly("wasm/intops.wasm");

//gold is what julia would return, but by casting to i32 and back to i64 or f64

Deno.test("-------------------- intops --------------------", () => {});

const a = 3;
const b = 5;

Deno.test("add", () => {
  const r = wasm.add(a, b);
  const gold = 8;
  assertEquals(r, gold);
});

Deno.test("sub", () => {
  const r = wasm.sub(a, b);
  const gold = -2;
  assertEquals(r, gold);
});

Deno.test("mul", () => {
  const r = wasm.mul(a, b);
  const gold = 15;
  assertEquals(r, gold);
});

Deno.test("int div", () => {
  const r = wasm._div(b, a);
  const gold = 1;
  assertEquals(r, gold);
});

Deno.test("div", () => {
  const r = wasm._div2(b, a);
  const gold = 1.6666666269302368;
  assertEquals(r, gold);
});

Deno.test("shl", () => {
  const r = wasm._shl(a, b);
  const gold = 96;
  assertEquals(r, gold);

  const r2 = wasm._shl(-a, b);
  const gold2 = -96;
  assertEquals(r2, gold2);
});

Deno.test("shr", () => {
  const r = wasm._shr(17, 2);
  const gold = 4;
  assertEquals(r, gold);

  const r2 = wasm._shr(-17, 2);
  const gold2 = -5;
  assertEquals(r2, gold2);

  const r3 = wasm._shr(17, 8);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("eq", () => {
  const r = wasm._eq(a, b);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm._eq(a, a);
  const gold2 = 1;
  assertEquals(r2, gold2);
});

Deno.test("egal", () => {
  const r = wasm._egal(a, b);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm._egal(a, a);
  const gold2 = 1;
  assertEquals(r2, gold2);
});

Deno.test("ne", () => {
  const r = wasm._ne(a, b);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._ne(a, a);
  const gold2 = 0;
  assertEquals(r2, gold2);
});

Deno.test("lt", () => {
  const r = wasm._lt(a, b);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._lt(a, a);
  const gold2 = 0;
  assertEquals(r2, gold2);
});

Deno.test("gt", () => {
  const r = wasm._gt(a, b);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm._gt(a, a);
  const gold2 = 0;
  assertEquals(r2, gold2);
});

Deno.test("le", () => {
  const r = wasm._le(a, b);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._le(a, a);
  const gold2 = 1;
  assertEquals(r2, gold2);
});

Deno.test("ge", () => {
  const r = wasm._ge(a, b);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm._ge(a, a);
  const gold2 = 1;
  assertEquals(r2, gold2);
});

Deno.test("-------------------- intops (bits) --------------------", () => {});

Deno.test("leading_zeros", () => {
  const r = wasm._leading_zeros(a);
  const gold = 30; // julia> leading_zeros(convert(Int32, 3))
  assertEquals(r, gold);
});

Deno.test("count_ones", () => {
  const r = wasm._count_ones(7);
  const gold = 3;
  assertEquals(r, gold);

  const r2 = wasm._count_ones(8);
  const gold2 = 1;
  assertEquals(r2, gold2);
});

Deno.test("mod", () => {
  const r = wasm._mod(b, a);
  const gold = 2;
  assertEquals(r, gold);
});

Deno.test("mod2", () => {
  const r = wasm._mod2(b, a);
  const gold = 2;
  assertEquals(r, gold);
});

Deno.test("-------------------- intops (bools) --------------------", () => {});

Deno.test("and", () => {
  const r = wasm._and(true, false);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm._and(true, true);
  const gold2 = 1;
  assertEquals(r2, gold2);

  const r3 = wasm._and(false, false);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("or", () => {
  const r = wasm._or(true, false);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._or(true, true);
  const gold2 = 1;
  assertEquals(r2, gold2);

  const r3 = wasm._or(false, false);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("xor", () => {
  const r = wasm._xor(true, false);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._xor(true, true);
  const gold2 = 0;
  assertEquals(r2, gold2);

  const r3 = wasm._xor(false, false);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("xor2", () => {
  const r = wasm._xor2(true, false);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._xor2(true, true);
  const gold2 = 0;
  assertEquals(r2, gold2);

  const r3 = wasm._xor2(false, false);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("not", () => {
  const r = wasm._not(true);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm._not(false);
  const gold2 = 1;
  assertEquals(r2, gold2);
});
