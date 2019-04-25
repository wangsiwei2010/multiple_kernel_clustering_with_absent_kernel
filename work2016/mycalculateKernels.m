function KH = mycalculateKernels(X)

[num,numker] = size(X);
meanx = mean(X); stdx = std(X);
X = (X - repmat(meanx,num,1))./repmat(stdx,num,1);
KH = zeros(num,num,numker);
for p =1:numker
    KH(:,:,p) = X(:,p)*X(:,p)'+1e-6*eye(num);
end
KH = kcenter(KH);
KH = knorm(KH);