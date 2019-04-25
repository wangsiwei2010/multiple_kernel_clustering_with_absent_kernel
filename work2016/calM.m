function HE0 = calM(K)

numker = size(K,3);
HE0 = zeros(numker);
for p =1:numker
    for q = p:numker
        HE0(p,q) = trace(K(:,:,p)'*K(:,:,q));
    end
end
HE0 = (HE0+HE0')-diag(diag(HE0));