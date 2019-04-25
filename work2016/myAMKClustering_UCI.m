clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'sonar'; %%% flower17; flower102; CCV; caltech101_numofbasekernel_10
load(['D:\myWork\xinwangwork\AbsentMKL\30GroupData\',dataName,'_info'],'X','Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numclass = length(unique(Y));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = mycalculateKernels(X);
qnorm = 2;
[H_normalized,gamma,obj] = mkkmeans_train(KH,numclass,qnorm);
res_gnd = myNMIACC(H_normalized,Y,numclass);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = [0.1:0.1:1.0];
for ie =1:length(epsionset)
    for iter = 1:30
        load([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        
        %%%%%%%%%%%--Zero-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        X_zero = zero_filling(X,S);
        KH1 = mycalculateKernels(X_zero);
        [H_normalized1,gamma1,obj1] = mkkmeans_train(KH1,numclass,qnorm);
        res(:,1) = myNMIACC(H_normalized1,Y,numclass);
        
        %%%%%%%%%%%--mean-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        X_mean = mean_filling(X,S);
        KH2 = mycalculateKernels(X_mean);
        [H_normalized2,gamma2,obj2] = mkkmeans_train(KH2,numclass,qnorm);
        res(:,2) = myNMIACC(H_normalized2,Y,numclass);
        
        %%%%%%%%%%%--knn-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        X_knn = KNN_filling(X,S);
        KH3 = mycalculateKernels(X_knn);
        [H_normalized3,gamma3,obj3] = mkkmeans_train(KH3,numclass,qnorm);
        res(:,3) = myNMIACC(H_normalized3,Y,numclass);
       
        %%%%%%%%%%%%%---EM-filling---%%%%%%%%%%%%%%%%%%%%%%%
        X_em = EM_filling(X,S);
        KH4 = mycalculateKernels(X_em);
        [H_normalized4,gamma4,obj4] = mkkmeans_train(KH4,numclass,qnorm);
        res(:,4) = myNMIACC(H_normalized4,Y,numclass);
        
        %%%%%%%%%--Laplacian-filling----%%%%%%%%%%%%%%%%%%%%%%
        alpha05 = 1e-3;
        KH5 = algorithm4(KH,S,numclass,alpha05);
        [H_normalized5,gamma5,obj5] = mkkmeans_train(KH5,numclass,qnorm);
        res(:,5) = myNMIACC(H_normalized5,Y,numclass);
        
        %%%%%%%%---Average---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [H_normalized6,gamma6,obj6,KH6] = myabsentmultikernelclustering(KH,S,numclass,qnorm);
        res(:,6) = myNMIACC(H_normalized6,Y,numclass);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        alignment(:,1) = calKernelAlignment(KH,KH1);
        alignment(:,2) = calKernelAlignment(KH,KH2);
        alignment(:,3) = calKernelAlignment(KH,KH3);
        alignment(:,4) = calKernelAlignment(KH,KH4);
        alignment(:,5) = calKernelAlignment(KH,KH5);
        alignment(:,6) = calKernelAlignment(KH,KH6);
        
        save([path,'work2016\myAbsentMKCres1\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','gamma1','gamma2','gamma3','gamma4','gamma5','obj5',...
            'res_gnd','alignment');
    end
end