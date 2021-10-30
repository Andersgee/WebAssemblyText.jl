#=
:(+) => "i32.add", # these consume 2 args 
:(-) => "i32.sub",
:(*) => "i32.mul",
:(div) => "i32.div_s", # julia 4/2 will return float. but div(4,2) wont
:(%) => "i32.rem_s",
:(%) => "i32.rem_s",
:(rem) => "i32.rem_s",
:(&&) => "i32.and",
:(||) => "i32.or",
:(⊻) => "i32.xor",
:(xor) => "i32.xor",

:(<<) => "i32.shl",
:(>>) => "i32.shr_s",
:(==) => "i32.eq",
# :(===) => "i32.eq", #handle this in a special way.
:(!=) => "i32.ne",
:(<) => "i32.lt_s",
:(>) => "i32.gt_s",
:(<=) => "i32.le_s",
:(>=) => "i32.ge_s",
:(!) => "i32.eqz", # these consume 1 arg
:(not_int) => "i32.eqz",
:(leading_zeros) => "i32.clz",
:(trailing_zeros) => "i32.ctz",
:(count_ones) => "i32.popcnt",
:(float) => "f32.convert_i32_s",
:(Int) => "i32.trunc_f32_s",
# :(^) => ["call \$powi",2],
# ""=>["i32.load",1]
# ""=>["i32.store",2]
# ""=>["i32.const",1]
=#

#int
add(a, b) = a + b
sub(a, b) = a - b
mul(a, b) = a * b
_div(a, b) = div(a, b) #should return int
_div2(a, b) = a / b #should return float
_mod(a, b) = mod(a, b)
_mod2(a, b) = a % b
_shl(a, b) = a << b
_shr(a, b) = a >> b #sign preserving
_eq(a, b) = a == b
_egal(a, b) = a === b #identical. (for immutable: same content on bit level. for mutable: type and adress equal)
_ne(a, b) = a != b
_lt(a, b) = a < b
_gt(a, b) = a > b
_le(a, b) = a <= b
_ge(a, b) = a >= b

#bool
_and(a,b) = a && b
_or(a, b) = a || b
_xor(a, b) = xor(a, b)
_xor2(a, b) = a ⊻ b
_not(a) = !a #intended for bools (but wasm dont have bools so actually equivalent to a == 0)
_not2(a) = Base.not_int(a) #intended for bools in julia (but wasm dont have bools so actually equivalent to a == 0)
#bits
_leading_zeros(a) = leading_zeros(a)
_trailing_zeros(a) = trailing_zeros(a)
_count_ones(a) = count_ones(a)
_float(a) = float(a) #int -> float
_Int(a) = Int(a) #whole float -> int

#=
# :(^) => ["call \$powi",2],
# ""=>["i32.load",1]
# ""=>["i32.store",2]
# ""=>["i32.const",1]
=#

function ops(a, b)
  
  add(a, b)
  sub(a, b)
  mul(a, b)
  _div(a, b)
  _div2(a, b)
  _shl(a, b)
  _shr(a, b)
  _eq(a, b)
  _egal(a, b)
  _ne(a, b)
  _lt(a, b)
  _gt(a, b)
  _le(a, b)
  _ge(a, b)

  #bits
  _leading_zeros(a)
  _trailing_zeros(a)
  _count_ones(a)
  _float(a)
  
  _mod(a, b)
  _mod2(a, b)
  #_not2(true)
  #_not2(1)
  
  t=true
  f=false
  #bool
  _and(t, f)
  _or(t, f)
  _xor(t, f)
  _xor2(t, f)
  _not(t)

  return nothing
end

function exports()
  ops(3, 5) #int ops
  #_mod2(3, 5)
end

exports()