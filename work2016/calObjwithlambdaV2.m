function [obj]= calObjwithlambdaV2(K,M,gamma,H,lambda)

num = size(K,1);
numker = size(K,3);
qnorm = 2;
%%%%%%%%%%%%%%%%%%%%%
KC  = mycombFun(K,gamma.^qnorm);
obj1 = trace(KC*(eye(num)-H*H'));
obj2 = -lambda*(gamma'*(M*ones(numker,1)-diag(M)));
obj = obj1+obj2;

