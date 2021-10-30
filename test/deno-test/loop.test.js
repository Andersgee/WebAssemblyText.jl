import webassembly from "./webassembly.js";
import { assertEquals } from "https://deno.land/std@0.88.0/testing/asserts.ts";

const wasm = await webassembly("wasm/loop.wasm");

Deno.test("-------------------- loop --------------------", () => {});

const a = 3;
const b = 5;

Deno.test("unitrange", () => {
  const r = wasm._unitrange(1, 9);
  const gold = 18.900001525878906;
  assertEquals(r, gold);

  const r2 = wasm._unitrange(-3, 4);
  const gold2 = 16.80000114440918;
  assertEquals(r2, gold2);
});

Deno.test("unitrange2", () => {
  const r = wasm._unitrange2(2, 9);
  const gold = 60.79999542236328;
  assertEquals(r, gold);
});

Deno.test("steprange", () => {
  const r = wasm._steprange(1, 2, 9);
  const gold = 10.5;
  assertEquals(r, gold);
});

Deno.test("while", () => {
  const r = wasm._while(3);
  const gold = 4.199999809265137;
  assertEquals(r, gold);
});
