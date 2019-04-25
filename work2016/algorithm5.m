function KH5 = algorithm5(KH,S)

num = size(KH,1);
numker = size(KH,3);
KH5 = zeros(num,num,numker);
for p =1:numker
    KH(S{p}.indx',S{p}.indx',p) = nan;
    KH5(:,:,p) = DataCompletion(KH(:,:,p),'KNN');
end
clear KH