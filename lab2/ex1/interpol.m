f = @(x) 1./ (1+ 25 *x.^2);
n = [10 20 30];
nP = n(1);
x = zeros(1, nP+1);
x_ch = zeros(1, nP+1);
for i=0:nP
    %x(i+1) = -1 + 2* i /nP;    
    x_ch(i+1) = -cos(pi .* i ./ nP);
end
maxErr = lagrangeStability(f, x_ch, 0.01)
%theoritical_error = lebeq_eqi(nP)
the_error = lebeq_ch(nP)

