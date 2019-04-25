function KH7 = algorithm7(KH,S)

num = size(KH,1);
numker = size(KH,3);
KH6 = zeros(num,num,numker);
for p =1:numker
    KH(S{p}.indx',S{p}.indx',p) = nan;
    KH6(:,:,p) = DataCompletion(KH(:,:,p),'KNN');
    KH6(:,:,p) = (KH6(:,:,p) +KH6(:,:,p)')/2;
end
clear KH