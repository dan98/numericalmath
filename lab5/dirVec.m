function d = dirVec(f, x, dir, h, type)
  if type == 0
    d = (f(x + h*dir) - f(x))/h;
  end
    
  if type == 1
    d = (f(x + h*dir) - f(x-h*dir))/(2*h);
  end
    
end
