clear
clc
warning off;
path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'heart'; %%% flower17; flower102; CCV; caltech101_numofbasekernel_10
load(['D:\myWork\xinwangwork\AbsentMKL\30GroupData\',dataName,'_info'],'X','Y');
[num,dim]= size(X);

epsionset = [0.1:0.1:1.0];
for ie =1:length(epsionset)
    S = generateMissingIndex(path,dataName,num,dim,Y,epsionset(ie));
end