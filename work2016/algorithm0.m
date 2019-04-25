function ImputedKM = algorithm0(K,S,k)
% KM is the Missing kernels
% S is the index of missing samples
% k is the k of k-nn
% ImputedKM is the imputed kernels
% ImputedKM is of the same size of KM
KM = algorithm2(K,S);
ImputedKM = KM;
numker = size(KM,3);
for p = 1 : numker
    % 针对第i个kernel进行补全
    Indx = setdiff(1:numker,p);
    % 第i个kernel中缺失的情况
    MisingIndex = S{p}.indx;
    % 计算knn
    TempK = sum(KM(:,:,Indx),3)/(numker-1);
    IDX = knnsearch(TempK,TempK(MisingIndex ,:) ,'k',k+1);
    % 矩阵补全
    for j = 1 : length(MisingIndex)
        heheTemp = mean(TempK(IDX(j,2:k+1) , :) , 1);
        ImputedKM(MisingIndex(j),:,p) = heheTemp;
        ImputedKM(:,MisingIndex(j),p) = heheTemp;
    end
    ImputedKM(:,:,p) = (ImputedKM(:,:,p)+ImputedKM(:,:,p)')/2;
end