clear
clc
warning off;
path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'musk1'; %%% flower17; flower102; CCV; caltech101_numofbasekernel_10
%% %% washington; wisconsin; texas; cornell
%% dataset_adni_com_nc2mci_new; dataset_adni_com_nc2ad_new

load(['D:\myWork\xinwangwork\myMKLMatrix\UCIKmatrix\',dataName,'_Kmatrix'],'Y');
% KH0 = KH(:,:,[1:2 10:12]);
% clear KH
% KH = KH0;
% save([path,'datasets\',dataName,'_numofbasekernel_',num2str(5),'.mat'],'KH','Y')
% % % load([path,'datasets\',dataName,'_Kmatrix'],'Ktrntrn','Ytrn');
% % % KH = Ktrntrn;
% % % Y = Ytrn;
% % % clear Ktrntrn Ytrn
% 
num = length(Y);
numker = 10;
%% epsionset = [0.05:0.05:0.5];
epsionset = [0.1:0.1:0.9];
for ie =1:length(epsionset)
    S = generateMissingIndex(path,dataName,num,numker,Y,epsionset(ie));
end