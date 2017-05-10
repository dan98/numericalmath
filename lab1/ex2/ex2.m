syms x;
format long e;
f = sin(x) + exp(x);
f_hand = matlabFunction(f);
df = diff(f,1);
df_hand = matlabFunction(df);
rng(10)
val = rand();
iMax = 52;
h0 = 1;
[dif, h] =diffConsistency(f_hand, df_hand, val, iMax, h0);