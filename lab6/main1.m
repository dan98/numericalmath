l = -100;
hf = @(t, y) (l*(y - sin(t)) + cos(t));
hdf = @(t, y) (l);

hex = @(t) (exp(l*t) + sin(t));

[rsx, rsu] = odeSolveTheta(hf, [0, 10], 1, hdf, 1/2, 0.001);

rsexact = rsu;
for i=1:length(rsu)
  rsexact(i) = hex(rsx(i));
end

plot(rsx, rsu);
hold on;
plot(rsx, rsexact);
