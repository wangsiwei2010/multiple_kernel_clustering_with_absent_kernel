function Kx = calKx(gamma,K,H,lambda,p)

numker = size(K,3);
num = size(K,1);
indx_p = setdiff(1:numker,p);
gamma_p = zeros(numker,1);
for q =1:numker-1
    gamma_p(q) = (gamma(p)+gamma(indx_p(q))-gamma(p)*gamma(indx_p(q)))/(1+(numker-1)*gamma(p)^2);
end
gamma_p(numker) = -gamma(p)^2/(2*lambda*(1+(numker-1)*gamma(p)^2));

KH = zeros(num,num,numker);
for q =1:numker-1
    KH(:,:,q) = K(:,:,indx_p(q));
end
KH(:,:,numker) = eye(num)-H*H';
clear K
Kx  = mycombFun(KH,gamma_p);