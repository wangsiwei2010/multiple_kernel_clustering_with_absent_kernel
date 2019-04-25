function KH7 = algorithm7(KH,S)

num = size(KH,1);
numker = size(KH,3);
KH7 = zeros(num,num,numker);
for p =1:numker
    KH(S{p}.indx',S{p}.indx',p) = nan;
    KH7(:,:,p) = DataCompletion(KH(:,:,p),'KNN');
    KH7(:,:,p) = (KH7(:,:,p) +KH7(:,:,p)')/2;
end
clear KH