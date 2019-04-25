function [alignment] = calKernelAlignment(KH,KHx)

numker = size(KH,3);
alignment = zeros(numker,1);
for p = 1:numker
    alignment(p) = trace(KH(:,:,p)*KHx(:,:,p)')/sqrt(trace(KH(:,:,p)*KH(:,:,p)')*trace(KHx(:,:,p)*KHx(:,:,p)'));
end