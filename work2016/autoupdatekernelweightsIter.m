function [gamma,lambda] = autoupdatekernelweightsIter(T,K,M)

nbkernel = size(K,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = zeros(nbkernel,1);
for p = 1 : nbkernel
    f(p) = trace(T'*K(:,:,p)*T);
end
gamma = ones(nbkernel,1)/nbkernel;
lambda = (gamma'*f)/sqrt(gamma'*M*gamma);
flag = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = -eye(nbkernel);
b = zeros(nbkernel,1);
Aeq = ones(nbkernel,1)';
beq = 1;
while flag
    [gamma,obj1]= fmincon(@(x)myfun1(x,f,M,lambda),gamma,A,b,Aeq,beq);
    if obj1<1e-6
        flag =0;
    else
        lambda = (gamma'*f)/sqrt(gamma'*M*gamma);
    end 
end

