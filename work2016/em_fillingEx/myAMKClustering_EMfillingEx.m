clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'flower17'; %%%caltech101_10base; flower17; flower102; psortPos; CCV;
%% psortPos, psortNeg; plant
addpath(genpath(path));
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
% load([path,'datasets\',dataName,'_Kmatrix'],'Ktrntrn','Ytrn');
% KH = Ktrntrn;
% Y = Ytrn;
% clear Ktrntrn Ytrn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numclass = length(unique(Y));
numker = size(KH,3);
num = size(KH,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = kcenter(KH);
KH = knorm(KH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = [0.6:0.1:0.6];
for ie =1:length(epsionset)
    for iter = 1:30
        load([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        qnorm = 2;
        %%%%%%%%%%%--Zero-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH1 = algorithm2(KH,S);
        [H_normalized1,gamma1,obj1] = mkkmeans_train(KH1,numclass,qnorm);
        res(:,1) = myNMIACC(H_normalized1,Y,numclass);
        %%%%%%%%%%%%%%%%--KNN-filling---%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         KH6 = algorithm5(KH,S);
%         [H_normalized6,gamma6,obj6] = mkkmeans_train(KH6,numclass,qnorm);
%         res(:,6) = myNMIACC(H_normalized6,Y,numclass);
        %%%%%%%%%%%%%%%--EM-filling---%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH7 = algorithm6(KH,S);
        [H_normalized7,gamma7,obj7] = mkkmeans_train(KH7,numclass,qnorm);
        res(:,7) = myNMIACC(H_normalized7,Y,numclass);

        
        save([path,'work2016\myAbsentMKCres1\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'_emFilling.mat'],'res','gamma7','KH7');
    end
end