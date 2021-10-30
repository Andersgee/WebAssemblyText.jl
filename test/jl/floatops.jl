#=
:(+) => "f32.add", # these consume 2 args 
:(-) => "f32.sub",
:(*) => "f32.mul",
:(/) => "f32.div",
:(==) => "f32.eq",
:(!=) => "f32.ne",
:(<) => "f32.lt",
:(>) => "f32.gt",
:(<=) => "f32.le",
:(>=) => "f32.ge",
:(min) => "f32.min",
:(max) => "f32.max",
:(copysign) => "f32.copysign",

:(abs) => "f32.abs", # these consume 1 arg
:(ceil) => "f32.ceil",
:(floor) => "f32.floor",
:(trunc) => "f32.trunc",
:(round) => "f32.nearest",
:(sqrt) => "f32.sqrt",
:(float) => "f32.convert_i32_s",
:(Int) => "i32.trunc_f32_s",
# :(^) => ["call \$pow",2],
# ""=>["f32.neg",1],
# ""=>["f32.load",1],
# ""=>["f32.store",2],
# ""=>["f32.const",1],
=#

add(a, b) = a + b
sub(a, b) = a - b
mul(a, b) = a * b
div(a, b) = a / b
eq(a, b) = a == b
ne(a, b) = a != b
lt(a, b) = a < b
gt(a, b) = a > b
le(a, b) = a <= b
ge(a, b) = a >= b
_min(a, b) = min(a, b)
_max(a, b) = max(a, b)
_copysign(a,b) = copysign(a,b)

_abs(a) = abs(a)
_ceil(a) = ceil(a)
_floor(a) = floor(a)
_trunc(a) = trunc(a)
_round(a) = round(a)
_sqrt(a) = sqrt(a)
_float(c) = float(c)
_Int(a) = Int(a)

function ops(a, b)
  add(a, b)
  sub(a, b)
  mul(a, b)
  div(a, b)
  eq(a, b)
  ne(a, b)
  lt(a, b)
  gt(a, b)
  le(a, b)
  ge(a, b)
  _min(a,b)
  _max(a,b)
  _copysign(a,b)

  _abs(a)
  _ceil(a)
  _floor(a)
  _trunc(a)
  _round(a)
  _sqrt(a)
  _float(3)
  _Int(a)

  return nothing
end

function exports()
  ops(2.0, 3.0) #float ops
  #ops(2, 3) #int ops
end

exports()