clear
clc
clf
warning off;

path = '/media/xinwang/软件/myWork/work2015/';
dataName = 'flower17'; %%%flower17; caltech101_10base; flower102; CCV; caltech101_numofbasekernel_10; bbcsport2view
%% %% washington; wisconsin; texas; cornell
epsionset = [0.1:0.1:0.9];
len = length(epsionset);
qnorm = 2;
numofalg = 1;
maxIter = 10;

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
        load([path,'work2016/myAbsentMKCres1/',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_alg8_iter_',num2str(iter),'.mat'],'res','alignment8');
        res_acc_10(ie,:) =  res(1,end);
        res_nmi_10(ie,:) =  res(2,end);
        res_pur_10(ie,:) =  res(3,end);
        res_alg_10(ie,:) =  alignment8;
    end
    res_acc_mean(iter,:) = mean(res_acc_10);
    res_nmi_mean(iter,:) = mean(res_nmi_10);
    res_pur_mean(iter,:) = mean(res_pur_10);
    res_alg_mean(iter,:) = mean(res_alg_10);
end
% [H(1),P1(1)] = ttest(res_acc_mean(:,1),res_acc_mean(:,5));
% [H(2),P1(2)] = ttest(res_acc_mean(:,2),res_acc_mean(:,5));
% [H(3),P1(3)] = ttest(res_acc_mean(:,3),res_acc_mean(:,5));
% [H(4),P1(4)] = ttest(res_acc_mean(:,4),res_acc_mean(:,5));
% P1(5) = 1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [H(1),P2(1)] = ttest(res_nmi_mean(:,1),res_nmi_mean(:,5));
% [H(2),P2(2)] = ttest(res_nmi_mean(:,2),res_nmi_mean(:,5));
% [H(3),P2(3)] = ttest(res_nmi_mean(:,3),res_nmi_mean(:,5));
% [H(4),P2(4)] = ttest(res_nmi_mean(:,4),res_nmi_mean(:,5));
% P2(5) = 1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [H(1),P3(1)] = ttest(res_pur_mean(:,1),res_pur_mean(:,5));
% [H(2),P3(2)] = ttest(res_pur_mean(:,2),res_pur_mean(:,5));
% [H(3),P3(3)] = ttest(res_pur_mean(:,3),res_pur_mean(:,5));
% [H(4),P3(4)] = ttest(res_pur_mean(:,4),res_pur_mean(:,5));
% P3(5) = 1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [H(1),P4(1)] = ttest(res_alg_mean(:,1),res_alg_mean(:,5));
% [H(2),P4(2)] = ttest(res_alg_mean(:,2),res_alg_mean(:,5));
% [H(3),P4(3)] = ttest(res_alg_mean(:,3),res_alg_mean(:,5));
% [H(4),P4(4)] = ttest(res_alg_mean(:,4),res_alg_mean(:,5));
% P4(5) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
res_acc_mean_std = [mean(res_acc_mean);std(res_acc_mean)]
res_nmi_mean_std = [mean(res_nmi_mean);std(res_nmi_mean)]
res_pur_mean_std = [mean(res_pur_mean);std(res_pur_mean)]
res_alg_mean_std = [mean(res_alg_mean);std(res_alg_mean)]