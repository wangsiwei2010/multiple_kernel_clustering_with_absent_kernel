clear
clc
warning off;

path = 'F:\work2015\';
dataName = 'flower102'; %%%caltech101_10base; flower17; flower102; caltech101_numofbasekernel_10; CCV;
%% psortPos, psortNeg; plant; proteinFold
addpath(genpath(path));
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numclass = length(unique(Y));
numker = size(KH,3);
num = size(KH,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = [0.1:0.1:0.9];
maxIter = 30;
totalmissRatio = zeros(length(epsionset),maxIter);
for ie =1:length(epsionset)
    for iter = 1:maxIter
        load([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        sum_p = 0;
        for p =1:numker
            m0 = length(S{p}.indx');
            miss_p = 2*num*m0-m0^2;
            sum_p = sum_p + miss_p;
        end
        totalmissRatio(ie,iter) =  sum_p/(num^2*numker);
    end
end
entryMissingRatio = sum(totalmissRatio,2)/maxIter;