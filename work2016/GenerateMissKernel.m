function KM = GenerateMissKernel(KH , S)
% KH is the origial kernel matrix
% S is the index of missing samples
% KM is the missing version of kernel matrixes
kernum = max(size(S));
ZEROs = zeros(size(KH , 1) ,  1);
for I = 1 : kernum
    Index = S{I}.indx;
    Czeros = repmat(ZEROs , [1 , length(Index)]);
    KH(Index , : , I) = Czeros';
    KH(: , Index , I) = Czeros;
end
KM = KH;
end