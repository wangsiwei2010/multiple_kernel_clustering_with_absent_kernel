function KH6 = algorithm6(KH,S)

num = size(KH,1);
numker = size(KH,3);
KH6 = zeros(num,num,numker);
for p =1:numker
    KH(S{p}.indx',S{p}.indx',p) = nan;
    KH6(:,:,p) = DataCompletion(KH(:,:,p),'EM');
    KH6(:,:,p) = (KH6(:,:,p) +KH6(:,:,p)')/2 +1e-8*eye(num);
end
clear KH