function [gamma,obj]= updateabsentkernelweights(T,K,lambda)

num = size(K,1);
nbkernel = size(K,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
U0 = eye(num)-T*T';
ZH1 = zeros(nbkernel,1);
for p = 1 : nbkernel
    ZH1(p) = trace(K(:,:,p)*U0);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ZH2 = zeros(nbkernel,1);
for p =1:nbkernel
    indexp = setdiff(1:nbkernel,p);
    for q = 1:nbkernel-1
        ZH2(p) = ZH2(p) + trace(K(:,:,p)*(-K(:,:,indexp(q))));
        %% ZH2(p) = ZH2(p) + (1/(nbkernel*num))*(- trace(K(:,:,indexp(q))*K(:,:,p)'));
    end
end
% ZH2 = ZH2+ZH2'-diag(diag(ZH2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = 2*diag(ZH1);
% f = zeros(nbkernel,1);
f = lambda*ZH2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = [];
b = [];
Aeq = ones(nbkernel,1)';
beq = 1;
lb  = zeros(nbkernel,1);
ub =  ones(nbkernel,1);
[gamma,obj]= quadprog(H,f,A,b,Aeq,beq,lb,ub);
gamma(gamma<1e-8)=0;
gamma = gamma/sum(gamma);