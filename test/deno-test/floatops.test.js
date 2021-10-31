import webassembly from "./webassembly.js";
import { assertEquals } from "https://deno.land/std@0.88.0/testing/asserts.ts";

const wasm = await webassembly("wasm/floatops.wasm");

//gold is what julia would return, but by casting to f32 and back to f64
//
// which is exactly whats happening here
// julia> a = convert(Float32, 2.4)
// julia> b = convert(Float32, 3.2)
// julia> gold = convert(Float64, a-b)
// julia> -0.7999999523162842

Deno.test("-------------------- floatops --------------------", () => {});

const a = 2.4;
const b = 3.2;

Deno.test("add", () => {
  const r = wasm.add(a, b);
  const gold = 5.600000381469727;
  assertEquals(r, gold);
});

Deno.test("sub", () => {
  const r = wasm.sub(a, b);
  const gold = -0.7999999523162842;
  assertEquals(r, gold);
});

Deno.test("mul", () => {
  const r = wasm.mul(a, b);
  const gold = 7.680000305175781;
  assertEquals(r, gold);
});

Deno.test("div", () => {
  const r = wasm._div(a, b);
  const gold = 0.75;
  assertEquals(r, gold);
});

Deno.test("eq", () => {
  const r = wasm.eq(a, b);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm.eq(a, a);
  const gold2 = 1;
  assertEquals(r2, gold2);
});

Deno.test("ne", () => {
  const r = wasm.ne(a, b);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm.ne(a, a);
  const gold2 = 0;
  assertEquals(r2, gold2);
});

Deno.test("lt", () => {
  const r = wasm.lt(a, b);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm.lt(b, a);
  const gold2 = 0;
  assertEquals(r2, gold2);

  const r3 = wasm.lt(a, a);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("gt", () => {
  const r = wasm.gt(a, b);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm.gt(b, a);
  const gold2 = 1;
  assertEquals(r2, gold2);

  const r3 = wasm.gt(a, a);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("le", () => {
  const r = wasm.le(a, b);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm.le(b, a);
  const gold2 = 0;
  assertEquals(r2, gold2);

  const r3 = wasm.le(a, a);
  const gold3 = 1;
  assertEquals(r3, gold3);
});

Deno.test("ge", () => {
  const r = wasm.ge(a, b);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm.ge(b, a);
  const gold2 = 1;
  assertEquals(r2, gold2);

  const r3 = wasm.ge(a, a);
  const gold3 = 1;
  assertEquals(r3, gold3);
});

Deno.test("min", () => {
  const r = wasm._min(a, b);
  const gold = 2.4000000953674316;
  assertEquals(r, gold);
});

Deno.test("max", () => {
  const r = wasm._max(a, b);
  const gold = 3.200000047683716;
  assertEquals(r, gold);
});

Deno.test("copysign", () => {
  const r = wasm._copysign(a, -b);
  const gold = -2.4000000953674316;
  assertEquals(r, gold);
});

Deno.test("abs", () => {
  const r = wasm._abs(-a);
  const gold = 2.4000000953674316;
  assertEquals(r, gold);
});

Deno.test("ceil", () => {
  const r = wasm._ceil(a);
  const gold = 3;
  assertEquals(r, gold);

  const r2 = wasm._ceil(-a);
  const gold2 = -2;
  assertEquals(r2, gold2);
});

Deno.test("floor", () => {
  const r = wasm._floor(a);
  const gold = 2;
  assertEquals(r, gold);

  const r2 = wasm._floor(-a);
  const gold2 = -3;
  assertEquals(r2, gold2);
});

Deno.test("trunc", () => {
  const r = wasm._trunc(a);
  const gold = 2;
  assertEquals(r, gold);

  const r2 = wasm._trunc(-a);
  const gold2 = -2;
  assertEquals(r2, gold2);
});

Deno.test("round", () => {
  //julia docs: rounds to the nearest integer,
  //with ties (fractional values of 0.5) being rounded to the nearest even integer
  const r = wasm._round(2.4);
  const gold = 2;
  assertEquals(r, gold);

  const r2 = wasm._round(2.6);
  const gold2 = 3;
  assertEquals(r2, gold2);

  const r3 = wasm._round(2.5);
  const gold3 = 2;
  assertEquals(r3, gold3);

  const r4 = wasm._round(1.5);
  const gold4 = 2;
  assertEquals(r4, gold4);

  //round(float) is translated to "f32.nearest" which indeed behaves the same way
});

Deno.test("sqrt", () => {
  const r = wasm._sqrt(a);
  const gold = 1.5491933822631836;
  assertEquals(r, gold);

  const r2 = wasm._sqrt(-a);
  const gold2 = NaN;
  assertEquals(r2, gold2);
});

Deno.test("float", () => {
  const r = wasm._float(3);
  const gold = 3;
  assertEquals(r, gold);
});

Deno.test("Int", () => {
  //const r = wasm._Int(a); //this works in wasm because I translate Int to "i32.trunc_f32_s".
  const r = wasm._Int(wasm._trunc(a)); //julia would need to trunc/round to avoid error
  const gold = 2;
  assertEquals(r, gold);
});
