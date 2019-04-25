function KH3 = algorithm3(KH,S)

num = size(KH,1);
numker = size(KH,3);
KH3 = zeros(num,num,numker);
for p =1:numker
    indx = setdiff(1:num,S{p}.indx');
    n0 = length(S{p}.indx');
    KAp = KH(indx,indx,p);
    KH3(indx,indx,p) = (KAp+KAp')/2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    KH3(indx,S{p}.indx',p) = repmat(mean(KAp,2),1,n0);
    KH3(S{p}.indx',indx,p) = repmat(mean(KAp,2),1,n0)';
    KH3(S{p}.indx',S{p}.indx',p) = repmat(mean(KH3(S{p}.indx',indx,p),2),1,n0);
end