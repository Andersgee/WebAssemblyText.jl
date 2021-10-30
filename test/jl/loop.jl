
function _unitrange(start,stop)
  s = 0.0
  for i = start:stop
      s += 2.1
  end
  return s
end

function _unitrange2(start,stop)
  s = 0.0
  for i = start:stop
      s = s + 2.1 + float(i)
  end
  return s
end

function _steprange(start,step,stop)
  s = 0.0
  for i = start:step:stop
      s += 2.1
  end
  return s
end

function _while(n)
  s = 0.0
  i=1
  while i<n
      s += 2.1
      i+=1
  end
  return s
end

function exports()
  _unitrange(1,2)
  _unitrange2(1,2)
  _steprange(1,2,3)
  _while(3)
end

exports()