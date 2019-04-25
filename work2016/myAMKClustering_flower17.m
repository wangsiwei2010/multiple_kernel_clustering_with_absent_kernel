clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'bbcsport2view'; %%%caltech101_10base; flower17; flower102; psortPos; CCV;
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
epsionset = [0.5:0.1:0.5];
for ie =1:length(epsionset)
    for iter = 16:30
        load([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        qnorm = 2;
        %%%%%%%%%%%--Zero-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH1 = algorithm2(KH,S);
        [H_normalized1,gamma1,obj1] = mkkmeans_train(KH1,numclass,qnorm);
        res(:,1) = myNMIACC(H_normalized1,Y,numclass);

        %%%%%%%%%%%--mean-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH2 = algorithm3(KH,S);
        [H_normalized2,gamma2,obj2] = mkkmeans_train(KH2,numclass,qnorm);
        res(:,2) = myNMIACC(H_normalized2,Y,numclass);

        %%%%%%%%%%%--knn-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH3 = algorithm0(KH,S,7);
        [H_normalized3,gamma3,obj3] = mkkmeans_train(KH3,numclass,qnorm);
        res(:,3) = myNMIACC(H_normalized3,Y,numclass);
% %         %%%%%%%%%%%---EM-filling---%%%%%%%%%%%%%%%%%%%%%%%
%         KH4 = algorithm6(KH,S);
%         [H_normalized4,gamma4,obj4] = mkkmeans_train(KH4,numclass,qnorm);
%         res(:,4) = myNMIACC(H_normalized4,Y,numclass);
        
        %%%%%%%%%--Laplacian-filling----%%%%%%%%%%%%%%%%%%%%%%
        alpha04 = 1e-3;
        KH4 = algorithm4(KH,S,numclass,alpha04);
        [H_normalized4,gamma4,obj4] = mkkmeans_train(KH4,numclass,qnorm);
        res(:,4) = myNMIACC(H_normalized4,Y,numclass);
        
        %%%%%%%%---Average---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [H_normalized5,gamma5,obj5,KH5] = myabsentmultikernelclustering(KH,S,numclass,qnorm);
        res(:,5) = myNMIACC(H_normalized5,Y,numclass);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        save([path,'work2016\myAbsentMKCres1\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','gamma1','gamma2','gamma3','gamma4','gamma5','obj5',...
            'KH1','KH2','KH3','KH4','KH5','Y');
    end
end