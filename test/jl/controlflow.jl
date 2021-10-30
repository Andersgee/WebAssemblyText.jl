function _if1(n)
  if (n>3)
    return n
  else
    return 7
  end
end

function _ifelse(n)
  return ifelse(n>3, n, 7)
end

function _continue1()
  s = 0.0
  for i = 1:9
    if (i == 3)
      continue
    end
    s += 2.1
  end
  return s
end

function _break1()
  s = 0.0
  for i = 1:9
    if (i == 3)
      break
    end
    s += 2.1
  end
  return s
end

function _nestedloop1()
  s = 0.0
  for i = 1:9
      s += 2.1
      for j=1:3
        s += 7.1
      end
  end
  return s
end

function _nestedloopwithinnercontinue1()
  s = 0.0
  for i = 1:9
      s += 2.1
      for j=1:3
        if (j == 2)
          continue
        end
        s += 7.1
      end
  end
  return s
end

function _nestedloopwithinnerbreak1()
  s = 0.0
  for i = 1:9
      s += 2.1
      for j=1:3
        if (j == 2)
          break
        end
        s += 7.1
      end
  end
  return s
end

#function _bitwiseAND()
# |
#end

function _logicalAND(k)
  k == 3 && return 9
  return k
end

function _logicalOR(k)
  k == 3 || return 9
  return k
end

#testing inspiration here: https://docs.julialang.org/en/v1/manual/control-flow/
function _if_elseif_else(x, y)
  if x < y
    return 1
  elseif x > y
    return -1
  else
    return 0
  end
end

#if blocks also return a value
function _ifblock_withreturn(x,y)
  if x < y
      0
  else
      1
  end
end

_ternary(x,y) = x < y ? 0 : 1
_multiternary(x,y) = x < y ? 1 : x > y ? -1 : 0

function _println(n)
  if n < 3
    println("This is a message visible as console.log().")
  else
    return 1
  end
  return 2
end



function _error(n)
  if n < 3
    error("This is a message visible as console.error(), followed by uncreachable (trap) in wasm execution.")
  else
    return 1
  end
  return 2
end

#=
function fact(n)
  n >= 0 || error("n must be non-negative")
  n == 0 && return 1
  n * fact(n-1)
end
=#

function exports()
  
  _if1(2)
  _ifelse(2)
  _continue1()
  _break1()

  _nestedloop1()
  _nestedloopwithinnercontinue1()
  _nestedloopwithinnerbreak1()

  _logicalAND(2)
  _logicalOR(2)

  _if_elseif_else(2,3)

  k = _ifblock_withreturn(2,3)
  k = _ternary(2,3)
  k = _multiternary(2,3)

  k = _println(5)
  k = _error(4)
end

exports()
