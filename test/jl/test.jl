scalaradd(a, b) = a + b

function sum(v)
  s = 0.0
  N = length(v)
  for i = 1:N
      s += v[i]
  end
  return s
end

# y = dot(a,b)
function dot(a, b)
  s = 0.0
  N = length(a)
  for i = 1:N
      s += a[i] * b[i]
  end
  return s
end

function tuplereturn(x)
  a = x * 1.2
  b = x * 1.3
  return a, b
end
function tuplecall(x)
  ab = tuplereturn(x)
  r = getfield(ab,1)
  return r
end


function exports()
  scalaradd(1.0, 2.0)

  a=randn(3,1)
  b=randn(3,1)
  dot(a,b)

  tuplereturn(1.2)
  tuplecall(2.1)

  sum(a)
end

exports()