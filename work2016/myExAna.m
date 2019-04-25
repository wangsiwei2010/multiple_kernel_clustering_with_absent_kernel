clear
clc
clf
warning off;

path = 'D:\myWork\work2015\';
dataName = 'facerecognition_numOfSamples_2000_numOfKernels_20'; %%%flower17; flower102; CCV; caltech101_numofbasekernel_10; bbcsport2view
epsionset = [0.1:0.1:0.9];
len = length(epsionset) ;
qnorm = 2;

numofalg = 5;
maxIter = 20;
res_acc_mean = zeros(len,numofalg);
res_nmi_mean = zeros(len,numofalg);
res_pur_mean = zeros(len,numofalg);
aln_sco_mean = zeros(len,numofalg);
for ie =1:len
    res_acc_10 = zeros(maxIter,numofalg);
    res_nmi_10 = zeros(maxIter,numofalg);
    res_pur_10 = zeros(maxIter,numofalg);
    aln_sco_10 = zeros(maxIter,numofalg);
    for iter =1:maxIter
        load([path,'work2016\myAbsentMKCres1\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','alignment','gamma1','gamma2','gamma3','gamma4',...
            'gamma5','res_gnd');
        res_acc_10(iter,:) =  res(1,:);
        res_nmi_10(iter,:) =  res(2,:);
        res_pur_10(iter,:) =  res(3,:);
        aln_sco_10(iter,:) =  sum([gamma1 gamma2 gamma3 gamma4 gamma5].*alignment);
        clear res alignment gamma1 gamma2 gamma3 gamma4 gamma5
    end
    res_acc_mean(ie,:) = mean(res_acc_10);
    res_nmi_mean(ie,:) = mean(res_nmi_10);
    res_pur_mean(ie,:) = mean(res_pur_10);
    aln_sco_mean(ie,:) = mean(aln_sco_10);
end
figure(1);
plot(epsionset,res_acc_mean(:,1),'-k^','LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10);
hold on
plot(epsionset,res_acc_mean(:,2),'-bo','LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',10);
hold on
plot(epsionset,res_acc_mean(:,3),'-mo','LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',10);
hold on
plot(epsionset,res_acc_mean(:,4),'-c^','LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',10);
hold on
plot(epsionset,res_acc_mean(:,numofalg),'-rs','LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',10);
hold on
plot(epsionset,res_gnd(1)*ones(len,1),'-gp','LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',10);
title('\fontsize{20}{Face}');
xlabel('\fontsize{20}{missing ratio}');
ylabel('\fontsize{20}{ACC}');
ylim([min(min(min(res_acc_mean)),res_gnd(1))-0.003 max(max(max(res_acc_mean)),res_gnd(1))+0.002]);
legend('\fontsize{12}{ZF+MKKM}','\fontsize{12}{MF+MKKM}','\fontsize{12}{KNN+MKKM}','\fontsize{12}{AF+MKKM [10]}',...
    '\fontsize{12}{proposed}','\fontsize{12}{Reference: MKKM}');

figure(2);
plot(epsionset,res_nmi_mean(:,1),'-k^','LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10);
hold on
plot(epsionset,res_nmi_mean(:,2),'-bo','LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',10);
hold on
plot(epsionset,res_nmi_mean(:,3),'-mo','LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',10);
hold on
plot(epsionset,res_nmi_mean(:,4),'-c^','LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',10);
hold on
plot(epsionset,res_nmi_mean(:,numofalg),'-rs','LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',10);
hold on
plot(epsionset,res_gnd(2)*ones(len,1),'-gp','LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',10);
title('\fontsize{20}{Face}');
xlabel('\fontsize{20}{missing ratio}');
ylabel('\fontsize{20}{NMI}');
ylim([min(min(min(res_nmi_mean)),res_gnd(2))-0.003 max(max(max(res_nmi_mean)),res_gnd(2))+0.002]);
legend('\fontsize{12}{ZF+MKKM}','\fontsize{12}{MF+MKKM}','\fontsize{12}{KNN+MKKM}','\fontsize{12}{AF+MKKM [10]}',...
    '\fontsize{12}{proposed}','\fontsize{12}{Reference: MKKM}');

% 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3);
plot(epsionset,res_pur_mean(:,1),'-k^','LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10);
hold on
plot(epsionset,res_pur_mean(:,2),'-bo','LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',10);
hold on
plot(epsionset,res_pur_mean(:,3),'-mo','LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',10);
hold on
plot(epsionset,res_pur_mean(:,4),'-c^','LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',10);
hold on
plot(epsionset,res_pur_mean(:,numofalg),'-rs','LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',10);
hold on
plot(epsionset,res_gnd(3)*ones(len,1),'-gp','LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',10);
title('\fontsize{20}{Face}');
xlabel('\fontsize{20}{missing ratio}');
ylabel('\fontsize{20}{Purity}');
ylim([min(min(min(res_pur_mean)),res_gnd(3))-0.003 max(max(max(res_pur_mean)),res_gnd(3))+0.002]);
legend('\fontsize{12}{ZF+MKKM}','\fontsize{12}{MF+MKKM}','\fontsize{12}{KNN+MKKM}','\fontsize{12}{AF+MKKM [10]}',...
    '\fontsize{12}{proposed}','\fontsize{12}{Reference: MKKM}');

% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4);
plot(epsionset,aln_sco_mean(:,1),'-k^','LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',10);
hold on
plot(epsionset,aln_sco_mean(:,2),'-bo','LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',10);
hold on
plot(epsionset,aln_sco_mean(:,3),'-mo','LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',10);
hold on
% plot(epsionset,aln_sco_mean(:,4),'-gp','LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',10);
% hold on
plot(epsionset,aln_sco_mean(:,4),'-c^','LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',10);
hold on
plot(epsionset,aln_sco_mean(:,numofalg),'-rs','LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',10);
title('\fontsize{20}{Face}');
xlabel('\fontsize{20}{missing ratio}');
ylabel('\fontsize{20}{alignment}');
ylim([min(min(aln_sco_mean))-0.005 max(max(aln_sco_mean))+0.002]);
legend('\fontsize{12}{ZF+MKKM}','\fontsize{12}{MF+MKKM}','\fontsize{12}{KNN+MKKM}','\fontsize{12}{AF+MKKM [10]}',...
    '\fontsize{12}{proposed}');