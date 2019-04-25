function [c,ceq] = mycon1(x)
c = [];
ceq = x'*x-1;