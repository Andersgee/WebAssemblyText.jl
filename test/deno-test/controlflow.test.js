import webassembly from "./webassembly.js";
import {
  assertEquals,
  assertThrows,
} from "https://deno.land/std@0.88.0/testing/asserts.ts";

const wasm = await webassembly("wasm/controlflow.wasm");

Deno.test("-------------------- controlflow --------------------", () => {});

const a = 3;
const b = 5;

Deno.test("if1", () => {
  const r = wasm._if1(5);
  const gold = 5;
  assertEquals(r, gold);

  const r2 = wasm._if1(1);
  const gold2 = 7;
  assertEquals(r2, gold2);
});

Deno.test("ifelse", () => {
  const r = wasm._ifelse(5);
  const gold = 5;
  assertEquals(r, gold);

  const r2 = wasm._ifelse(1);
  const gold2 = 7;
  assertEquals(r2, gold2);
});

Deno.test("continue1", () => {
  const r = wasm._continue1();
  const gold = 16.80000114440918;
  assertEquals(r, gold);
});

Deno.test("break1", () => {
  const r = wasm._break1();
  const gold = 4.199999809265137;
  assertEquals(r, gold);
});

Deno.test("nestedloop1", () => {
  const r = wasm._nestedloop1();
  const gold = 210.6000518798828;
  assertEquals(r, gold);
});

Deno.test("nestedloopwithinnercontinue1", () => {
  const r = wasm._nestedloopwithinnercontinue1();
  const gold = 146.6999969482422;
  assertEquals(r, gold);
});

Deno.test("nestedloopwithinnerbreak1", () => {
  const r = wasm._nestedloopwithinnerbreak1();
  const gold = 82.79998779296875;
  assertEquals(r, gold);
});

Deno.test("logicalAND", () => {
  const r = wasm._logicalAND(3);
  const gold = 9;
  assertEquals(r, gold);

  const r2 = wasm._logicalAND(4);
  const gold2 = 4;
  assertEquals(r2, gold2);
});

Deno.test("logicalOR", () => {
  const r = wasm._logicalOR(3);
  const gold = 3;
  assertEquals(r, gold);

  const r2 = wasm._logicalOR(4);
  const gold2 = 9;
  assertEquals(r2, gold2);
});

Deno.test("if elseif else", () => {
  const r = wasm._if_elseif_else(2, 2);
  const gold = 0;
  assertEquals(r, gold);

  const r2 = wasm._if_elseif_else(2, 3);
  const gold2 = 1;
  assertEquals(r2, gold2);

  const r3 = wasm._if_elseif_else(4, 3);
  const gold3 = -1;
  assertEquals(r3, gold3);
});

Deno.test("ifblock with return", () => {
  const r = wasm._ifblock_withreturn(2, 2);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._ifblock_withreturn(2, 3);
  const gold2 = 0;
  assertEquals(r2, gold2);
});

Deno.test("ternary", () => {
  const r = wasm._ternary(2, 2);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._ternary(2, 3);
  const gold2 = 0;
  assertEquals(r2, gold2);
});

Deno.test("println", () => {
  const r = wasm._println(2);
  const gold = 2; //expect a console.log and return 2
  assertEquals(r, gold);

  const r2 = wasm._println(4);
  const gold2 = 1; //just expect return 1;
  assertEquals(r2, gold2);

  const r3 = wasm._println(6);
  const gold3 = 1; //just expect return 1;
  assertEquals(r2, gold3);
});

Deno.test("multiternary", () => {
  const r = wasm._multiternary(2, 3);
  const gold = 1;
  assertEquals(r, gold);

  const r2 = wasm._multiternary(3, 2);
  const gold2 = -1;
  assertEquals(r2, gold2);

  const r3 = wasm._multiternary(2, 2);
  const gold3 = 0;
  assertEquals(r3, gold3);
});

Deno.test("error (without error)", () => {
  const r = wasm._error(4);
  const gold = 1;
  assertEquals(r, gold);
});

Deno.test("error (with Error: uncreachable)", () => {
  assertThrows(
    () => {
      const r = wasm._error(2);
    },
    Error,
    "unreachable"
  );
});
