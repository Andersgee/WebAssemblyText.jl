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

function _booleanif(b)
  if (b)
    return 2
  else
    return 4
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
    return 1.5
  end
end


function fact(n)
  n >= 0 || error("n must be non-negative")
  n == 0 && return 1
  n * fact(n-1) #recursion
end

#=
#wasm cant have Union types 
function _unstablereturntype(x)
  x > 0 && return 1
  return 2.3
end
=#

t(x) = x>0 ? true : false
f(x) = x>0 ? false : true

function shortcircuitevaluation(a,b)
  #https://docs.julialang.org/en/v1/manual/control-flow/#Short-Circuit-Evaluation
  r1 = t(a) && f(b) #false
  r2 = f(a) && t(b) #false
  r3 = f(a) && f(b) #false
  r4 = t(a) || t(b) #true
  r5 = t(a) || f(b) #true
  r6 = f(a) || t(b) #true
  r7 = f(a) || f(b) #false
 
  if !r1 && !r2 && !r3 && r4 && r5 && r6 && !r7
    #expected.
    return 7
  else
    return 9
  end
end

function shortcircuitevaluation_constant(a,b)
  r1 = t(1) && f(2) #false, always, meaning r1 is actually a constant
  r2 = f(a) && t(b) #false
 
  if !r1 && !r2
    #expected.
    return 7
  else
    return 9
  end
end


function _unstablevariabletype()
  x = 1
  x = 1.2
  return x
end

function _unstablevariabletype2()
  x = 2 * 2.3
  return x*4.1
end

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

  fact(5)
  #_unstablereturntype(0) #float
  #_unstablereturntype(1) #int

  #_unstablevariabletype()
  #_unstablevariabletype2()
  shortcircuitevaluation(1,2)
  shortcircuitevaluation_constant(1,2)

  _booleanif(true)
  

end

exports()
