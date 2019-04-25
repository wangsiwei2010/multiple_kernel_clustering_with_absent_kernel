clear
clc
clf
warning off;

path = 'D:\myWork\work2015\';
dataName = 'cornell'; %%%flower17; caltech101_10base; flower102; CCV; caltech101_numofbasekernel_10; bbcsport2view
%% cornell; texas; washington; wisconsin
epsionset = [0.1:0.1:0.9];
len = length(epsionset);
qnorm = 2;
numofalg = 2;
maxIter = 30;

res_acc_mean = zeros(maxIter,numofalg);
res_nmi_mean = zeros(maxIter,numofalg);
res_pur_mean = zeros(maxIter,numofalg);
res_alg_mean = zeros(maxIter,numofalg);
for iter =1:maxIter
    res_acc_10 = zeros(len,numofalg);
    res_nmi_10 = zeros(len,numofalg);
    res_pur_10 = zeros(len,numofalg);
    res_alg_10 = zeros(len,numofalg);
    for ie =1:len
        load([path,'work2016\rebuttalExperiments\rebuttalResults\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res');
        res_acc_10(ie,:) =  res(1,:);
        res_nmi_10(ie,:) =  res(2,:);
        res_pur_10(ie,:) =  res(3,:);
    end
    res_acc_mean(iter,:) = mean(res_acc_10);
    res_nmi_mean(iter,:) = mean(res_nmi_10);
    res_pur_mean(iter,:) = mean(res_pur_10);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res_acc_mean_std = [mean(res_acc_mean);std(res_acc_mean)]
res_nmi_mean_std = [mean(res_nmi_mean);std(res_nmi_mean)]
res_pur_mean_std = [mean(res_pur_mean);std(res_pur_mean)]