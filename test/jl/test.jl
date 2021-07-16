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

# y = W*X
mul(W, X) = mul_(zeros(size(W,1), size(X,2)), W, X)
function mul_(y, W, X)
    szW = size(W)
    szX = size(X)
    s = 0.0
    for n = 1:szX[2]
        for i = 1:szW[1]
            s = 0.0
            for j = 1:szW[2]
                s += W[i,j] * X[j,n]
            end
            y[i,n] = s
        end
    end
    return y
end

# y = W*X .+ b
muladd(W, X, b) = muladd_(zeros(size(W,1), size(X,2)), W, X, b)
function muladd_(y, W, X, b)
    szW = size(W)
    szX = size(X)
    s = 0.0
    for n = 1:szX[2]
        for i = 1:szW[1]
            s = 0.0
            for j = 1:szW[2]
                s += W[i,j] * X[j,n]
            end
            y[i,n] = s + b[i]
        end
    end
    return y
end

# y = a .+ b
add(a, b) = add_(zeros(size(a)), a, b)
function add_(r, a, b)
  N = length(r)
  for i = 1:N
      r[i] = a[i] + b[i]
  end
  return r
end


function exports()
  scalaradd(1.0, 2.0)

  a=randn(3,1)
  b=randn(3,1)
  dot(a,b)
  res = add(a,b)

  tuplereturn(1.2)
  tuplecall(2.1)

  M1=randn(4,2)
  M2=randn(2,5)
  r = mul(M1,M2)

  b = randn(4,1)
  r2 = muladd(M1,M2, b)
  sum(a)
end

exports()