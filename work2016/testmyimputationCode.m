clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'mfeat'; %%% flower17; flower102; CCV; caltech101_numofbasekernel_10; caltech101_mit
%% %% washington; wisconsin; texas; cornell
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
% load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numclass = length(unique(Y));
numker = size(KH,3);
num = size(KH,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = kcenter(KH);
KH = knorm(KH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH0 = KH(1:10,1:10,2);
obs_indx = [1:8];
Kcc = KH(obs_indx,obs_indx,1);
KHx = mykernelimputation(KH0,Kcc,obs_indx);