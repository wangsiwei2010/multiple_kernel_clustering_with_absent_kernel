function x = myFeatureNormalization(x)

[num1]= size(x,1);
stdx = std(x);
indx_empty = find(stdx<1e-8);
indx1 = setdiff(1:size(x,2),indx_empty);
x1 = x(:,indx1);
meanx = mean(x1); stdx1 = std(x1);
x = (x1 - repmat(meanx,num1,1))./repmat(stdx1,num1,1);