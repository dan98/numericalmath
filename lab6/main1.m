close all
l = -1;
hf = @(t, y) (l*(y - sin(t)) + cos(t));
hdf = @(t, y) (l);

hex = @(t) (exp(l*t) + sin(t));
h = zeros(1,7);
plot(rsx, rsexact);
hold on;
col = ['-c', '-r', '-b','-c', '-r', '-b','-g' ];
for i=1:7
    %h(i) = 2 * 0.01 + (i-4) * 1e-4;
    h(i) = 2^(-i);
    [rsx, rsu] = odeSolveTheta(hf, [0, 10], 1, hdf, 1, h(i));
    plot(rsx, rsu,col(i) , 'DisplayName', sprintf('%f', h(i)) );
    
end
legend('show');

rsexact = rsu;
for i=1:length(rsu)
  rsexact(i) = hex(rsx(i));
end

