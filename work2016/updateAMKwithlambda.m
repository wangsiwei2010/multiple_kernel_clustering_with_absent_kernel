function [gamma,obj] = updateAMKwithlambda(H,K,M,lambda)

numker = size(K,3);
num = size(K,1);
d = zeros(numker,1);
for p =1:numker
    d(p) = trace(K(:,:,p)*(eye(num)-H*H'));
end
A = (numker-2)*ones(numker) + eye(numker);
%%%
HH = diag(d) + lambda*(A.*M);
%%%%%%%%%%%%%%%%%%%
f = -lambda*(M*ones(numker,1)-diag(M));
A = -eye(numker);
b = zeros(numker,1);
Aeq = ones(numker,1)';
beq = 1;
LB = zeros(numker,1);
UB = ones(numker,1);
[gamma,obj]= quadprog(HH,f,A,b,Aeq,beq,LB,UB);