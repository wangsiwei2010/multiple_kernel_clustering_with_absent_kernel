clear
clc
warning off;

path = 'D:\matlab\database\Kerneldata\XinWang\myMKLMatrix\UCIKmatrix\';
path2 = 'E:\64\matlab_program\JianpingMachineLearningGroup\5_Xinwang_work2015\';
dataName = 'iris_150'; %%%caltech101; caltech101_mit; flower17; flower102; UCI_DIGIT; proteinFold; CCV;
%% psortPos, psrotNeg; plant
addpath(genpath(path2));
load([path,dataName,'_Kmatrix'],'KH','Y');
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
epsionset = [0.1:0.1:0.9];
for ie =1:length(epsionset)
    for iter = 1:10
        load([path2,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        
        qnorm = 2;
        %%%%%%%%%%%--Zero-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH1 = algorithm2(KH,S);
        [H_normalized1,gamma1] = mkkmeans_train(KH1,numclass,qnorm);
        res(:,1) = myNMIACC(H_normalized1,Y,numclass);
        
        %%%%%%%%%%%--mean-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH2 = algorithm3(KH,S);
        [H_normalized2,gamma2] = mkkmeans_train(KH2,numclass,qnorm);
        res(:,2) = myNMIACC(H_normalized2,Y,numclass);
        
        %%%%%%%%%%%--knn-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KM = GenerateMissKernel(KH , S);
        KH0 = algorithm0(KM,S,3);
        [H_normalized0,gamma0] = mkkmeans_train(KH0,numclass,qnorm);
        res(:,3) = myNMIACC(H_normalized0,Y,numclass);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        alpha03 = 1e-2;
        KH3 = algorithm4(KH,S,numclass,alpha03);
        [H_normalized3,gamma3] = mkkmeans_train(KH3,numclass,qnorm);
        res(:,4) = myNMIACC(H_normalized3,Y,numclass);
        
        %%%%%%%%---Average---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [H_normalized4,gamma4,obj4] = myabsentmultikernelclustering(KH,S,numclass,qnorm);
        res(:,5) = myNMIACC(H_normalized4,Y,numclass);
        
        save([path2,'work2016\myAbsentMKCresV3\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','gamma1','gamma2','gamma3','gamma4','obj4');
    end
end