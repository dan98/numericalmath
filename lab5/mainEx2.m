format long
f = @(x) log(x*exp(x));
 c = -3/4;
 x_0 = 3;
 tol = 1e-12;
 maxIt = 25;
 
 it = 1:maxIt;
  %plot Aitken Iteration Level 0
 [root, flag, convHist_res_Aitken_st, convHist_x_Aitken] = aitkenIteration(f,c, x_0, tol, maxIt, 0);
 loglog(it, convHist_res_Aitken_st, 'DisplayName', 'static');
 hold on;
 
 %plot Aitken Iteration Level 1
 [root, flag, convHist_res_Aitken_1, convHist_x_Aitken] = aitkenIteration(f,c, x_0, tol, maxIt, 1);
 loglog(it, convHist_res_Aitken_1,'-r' ,'DisplayName', '1');
 
 %plot Aitken Iteration Level 2
 [root, flag, convHist_res_Aitken_2, convHist_x_Aitken] = aitkenIteration(f,c, x_0, tol, maxIt, 2);
 loglog(it, convHist_res_Aitken_2, '-k', 'DisplayName', '2');

  %plot Aitken Iteration Level 3
 [root, flag, convHist_res_Aitken, convHist_x_Aitken] = aitkenIteration(f,c, x_0, tol, maxIt, 3);
 loglog(it, convHist_res_Aitken,'-c' ,'DisplayName', '3');
 %Roundoff errors?? 
 legend('show');
 