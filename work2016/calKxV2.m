function Kx = calKxV2(gamma,K,H,lambda,p)

num = size(K,1);
numker = size(K,3);
indx_p = setdiff(1:numker,p);

Kx = gamma(p)^2*(eye(num)-H*H');
for q =1:numker-1
    Kx = Kx - lambda*gamma(indx_p(q))*K(:,:,indx_p(q));
end

