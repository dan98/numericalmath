syms x ; n =20; f =1/(1+ x ^2); df = diff (f ,1);
cdf = matlabFunction ( df );
for i = 1: n +1
df = diff ( df ,1); cdfn = matlabFunction ( df );
x = fzero ( cdfn ,0); M ( i ) = abs ( cdf ( x )); cdf = cdfn ;
end

z = linspace ( -5 ,5 ,10000);
for n =0:20; h =10/( n +1); x =[ -5: h :5];
c = poly ( x ); r ( n +1)= max ( polyval (c , z ));
r ( n +1)= r ( n +1)/ prod ([1: n +1]);
end
r ([3 ,9 ,15 ,21])
