clear
clc
clf
warning off;

path = 'D:\myWork\work2015\';
dataName = 'flower17'; 
%%%flower17; flower102; CCV; caltech101_numofbasekernel_10; bbcsport2view
%% %% %% washington; wisconsin; texas; cornell; caltech101_nTrain25_48

epsionset = [0.1:0.1:0.9];
len = length(epsionset) ;
qnorm = 2;
numofalg = 8;
maxIter = 10;
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
            '_clustering_iter_',num2str(iter),'.mat'],'res','alignment');
        res_acc_10(iter,1:end-1) =  res(1,1:end);
        res_nmi_10(iter,1:end-1) =  res(2,1:end);
        res_pur_10(iter,1:end-1) =  res(3,1:end);
        aln_sco_10(iter,1:end-1) =  alignment(1:end);
        load([path,'work2016\myAbsentMKCres1\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_alg8_iter_',num2str(iter),'.mat'],'res','alignment');
        res_acc_10(iter,end) = res(1,end);
        res_nmi_10(iter,end) = res(2,end);
        res_pur_10(iter,end) = res(3,end);
        aln_sco_10(iter,end) = alignment(end);
    end
    res_acc_mean(ie,:) = mean(res_acc_10);
    res_nmi_mean(ie,:) = mean(res_nmi_10);
    res_pur_mean(ie,:) = mean(res_pur_10);
    aln_sco_mean(ie,:) = mean(aln_sco_10);
end
figure(1);
H1 = plot(epsionset,res_acc_mean(:,1),'-.k^',epsionset,res_acc_mean(:,2),'-.bo',epsionset,res_acc_mean(:,3),'-.mo',...
    epsionset,res_acc_mean(:,4),'-.c^',epsionset,res_acc_mean(:,5),'-rs',epsionset,res_acc_mean(:,6),'-gh',...
    epsionset,res_acc_mean(:,7),'-bd',epsionset,res_acc_mean(:,8),'-r*');
set(H1(1),'LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',8)
set(H1(2),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H1(3),'LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',8)
set(H1(4),'LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',8)
set(H1(5),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
set(H1(6),'LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',8)
set(H1(7),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H1(8),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('missing ratio','FontSize',30)
ylabel('ACC','FontSize',30)
title('Caltech102-25','FontSize',30);
ylim([min(min(res_acc_mean))-0.002 max(max(res_acc_mean))+0.002]);
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legend(H1(1:4),'\fontsize{14}{MKKM+ZF}','\fontsize{14}{MKKM+MF}','\fontsize{14}{MKKM+KNN}','\fontsize{14}{MKKM+AF}');
legend boxoff;
AH1 = axes('position',get(gca,'position'),'visible','off');
legend(AH1,H1(5:8),'\fontsize{14}{MKKM-IK+ZF}','\fontsize{14}{MKKM-IK+MF}','\fontsize{14}{MKKM-IK+KNN}',...
    '\fontsize{14}{MKKM-IK+  \lambda}');
legend boxoff;


figure(2);
H2 = plot(epsionset,res_nmi_mean(:,1),'-.k^',epsionset,res_nmi_mean(:,2),'-.bo',epsionset,res_nmi_mean(:,3),'-.mo',...
    epsionset,res_nmi_mean(:,4),'-.c^',epsionset,res_nmi_mean(:,5),'-rs',epsionset,res_nmi_mean(:,6),'-gh',...
    epsionset,res_nmi_mean(:,7),'-bd',epsionset,res_nmi_mean(:,8),'-r*');
set(H2(1),'LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',8)
set(H2(2),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H2(3),'LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',8)
set(H2(4),'LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',8)
set(H2(5),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
set(H2(6),'LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',8)
set(H2(7),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H2(8),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('missing ratio','FontSize',30)
ylabel('NMI','FontSize',30)
title('Caltech102-25','FontSize',30);
ylim([min(min(res_nmi_mean))-0.002 max(max(res_nmi_mean))+0.002]);
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legend(H2(1:4),'\fontsize{14}{MKKM+ZF}','\fontsize{14}{MKKM+MF}','\fontsize{14}{MKKM+KNN}','\fontsize{14}{MKKM+AF}');
legend boxoff;
AH2 = axes('position',get(gca,'position'),'visible','off');
legend(AH2,H2(5:8),'\fontsize{14}{MKKM-IK+ZF}','\fontsize{14}{MKKM-IK+MF}','\fontsize{14}{MKKM-IK+KNN}',...
    '\fontsize{14}{MKKM-IK+  \lambda}');
legend boxoff;

figure(3);
H3 = plot(epsionset,res_pur_mean(:,1),'-.k^',epsionset,res_pur_mean(:,2),'-.bo',epsionset,res_pur_mean(:,3),'-.mo',...
    epsionset,res_pur_mean(:,4),'-.c^',epsionset,res_pur_mean(:,5),'-rs',epsionset,res_pur_mean(:,6),'-gh',...
    epsionset,res_pur_mean(:,7),'-bd',epsionset,res_pur_mean(:,8),'-r*');
set(H3(1),'LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',8)
set(H3(2),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H3(3),'LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',8)
set(H3(4),'LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',8)
set(H3(5),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
set(H3(6),'LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',8)
set(H3(7),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H3(8),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('missing ratio','FontSize',30)
ylabel('Purity','FontSize',30)
title('Caltech102-25','FontSize',30);
ylim([min(min(res_pur_mean))-0.002 max(max(res_pur_mean))+0.002]);
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legend(H3(1:4),'\fontsize{14}{MKKM+ZF}','\fontsize{14}{MKKM+MF}','\fontsize{14}{MKKM+KNN}','\fontsize{14}{MKKM+AF}');
legend boxoff;
AH3 = axes('position',get(gca,'position'),'visible','off');
legend(AH3,H3(5:8),'\fontsize{14}{MKKM-IK+ZF}','\fontsize{14}{MKKM-IK+MF}','\fontsize{14}{MKKM-IK+KNN}',...
    '\fontsize{14}{MKKM-IK+  \lambda}');
legend boxoff;


figure(4);
H4 = plot(epsionset,aln_sco_mean(:,1),'-.k^',epsionset,aln_sco_mean(:,2),'-.bo',epsionset,aln_sco_mean(:,3),'-.mo',...
    epsionset,aln_sco_mean(:,4),'-.c^',epsionset,aln_sco_mean(:,5),'-rs',epsionset,aln_sco_mean(:,6),'-gh',...
    epsionset,aln_sco_mean(:,7),'-bd',epsionset,aln_sco_mean(:,8),'-r*');
set(H4(1),'LineWidth',2, 'MarkerEdgeColor','k', 'MarkerFaceColor','k', 'MarkerSize',8)
set(H4(2),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H4(3),'LineWidth',2, 'MarkerEdgeColor','m', 'MarkerFaceColor','m', 'MarkerSize',8)
set(H4(4),'LineWidth',2, 'MarkerEdgeColor','c', 'MarkerFaceColor','c', 'MarkerSize',8)
set(H4(5),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
set(H4(6),'LineWidth',2, 'MarkerEdgeColor','g', 'MarkerFaceColor','g', 'MarkerSize',8)
set(H4(7),'LineWidth',2, 'MarkerEdgeColor','b', 'MarkerFaceColor','b', 'MarkerSize',8)
set(H4(8),'LineWidth',2, 'MarkerEdgeColor','r', 'MarkerFaceColor','r', 'MarkerSize',8)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xlabel('missing ratio','FontSize',30)
ylabel('Alignment','FontSize',30)
title('Caltech102-25','FontSize',30);
ylim([min(min(aln_sco_mean))-0.002 max(max(aln_sco_mean))+0.002]);
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
legend(H4(1:4),'\fontsize{14}{MKKM+ZF}','\fontsize{14}{MKKM+MF}','\fontsize{14}{MKKM+KNN}','\fontsize{14}{MKKM+AF}');
legend boxoff;
AH4 = axes('position',get(gca,'position'),'visible','off');
legend(AH4,H4(5:8),'\fontsize{14}{MKKM-IK+ZF}','\fontsize{14}{MKKM-IK+MF}','\fontsize{14}{MKKM-IK+KNN}',...
    '\fontsize{14}{MKKM-IK+  \lambda}');
legend boxoff;