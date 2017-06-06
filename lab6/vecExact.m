function rs = vecExact(t, R)
  w = 2*pi*(R^(-3/2));
  x0 = R*[cos(w*t); sin(w*t); 0];
  v0 = R*[-w*sin(w*t); w*cos(w*t); 0];
  rs = [v0; x0];
end
