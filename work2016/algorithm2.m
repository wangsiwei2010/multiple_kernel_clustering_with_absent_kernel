function KH2 = algorithm2(KH,S)

num = size(KH,1);
numker = size(KH,3);
KH2 = zeros(num,num,numker);
for p =1:numker
    indx = setdiff(1:num,S{p}.indx');
    KAp = KH(indx,indx,p);
    KH2(indx,indx,p) = (KAp+KAp')/2;
end
clear KH