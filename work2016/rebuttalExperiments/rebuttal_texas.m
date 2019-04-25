clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'washington';
%% cornell; texas; washington; wisconsin
load([path,'datasets\',dataName,'_Kmatrix.mat'],'KH','Y','Xf');
epsionset = [0.9:0.1:0.9];
numclass = length(unique(Y));
num = size(KH,1);
for ie =1:length(epsionset)
    for iter = 1:30
        load([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        qnorm = 2;
        
        lamda=1e-2;
        obs_view1 = setdiff(1:num,S{1}.indx);
        obs_view2 = setdiff(1:num,S{2}.indx);
        obs_view1andview2 = intersect(obs_view1,obs_view2);
        obs_view1notview2 = setdiff(obs_view1,obs_view1andview2);
        obs_view2notview1 = setdiff(obs_view2,obs_view1andview2);
        Xfeature1 = Xf{1}.feature;
        Xfeature2 = Xf{2}.feature;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        xpaired = Xfeature1(obs_view1andview2,:);
        ypaired = Xfeature2(obs_view1andview2,:);
        xsingle = Xfeature1(obs_view1notview2,:);
        ysingle = Xfeature2(obs_view2notview1,:);
        H_normalized1 = myPVCclust(xpaired,ypaired,xsingle,ysingle,numclass,lamda);
        res(:,1) = myNMIACC(H_normalized1,Y,numclass);
       
        %%%%%%%%%%%--Zero-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH1 = algorithm2(KH(:,:,[1,2]),S);
        [H_normalized1,gamma1,obj1] = mkkmeans_train(KH1,numclass,qnorm);
        res(:,2) = myNMIACC(H_normalized1,Y,numclass);
        
        %%%%%%%%%%%--mean-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH2 = algorithm3(KH(:,:,[1,2]),S);
        [H_normalized2,gamma2,obj2] = mkkmeans_train(KH2,numclass,qnorm);
        res(:,3) = myNMIACC(H_normalized2,Y,numclass);
        
        %%%%%%%%%%%--knn-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH3 = algorithm0(KH(:,:,[1,2]),S,7);
        [H_normalized3,gamma3,obj3] = mkkmeans_train(KH3,numclass,qnorm);
        res(:,4) = myNMIACC(H_normalized3,Y,numclass);
        
%         %         %%%%%%%%%%%---EM-filling---%%%%%%%%%%%%%%%%%%%%%%%
%         KH4 = algorithm6(KH(:,:,[1,2]),S);
%         [H_normalized4,gamma4,obj4] = mkkmeans_train(KH4,numclass,qnorm);
%         res(:,5) = myNMIACC(H_normalized4,Y,numclass);
        
        %%%%%%%%%--Laplacian-filling----%%%%%%%%%%%%%%%%%%%%%%
        alpha04 = 1e-3;
        KH4 = algorithm4(KH(:,:,[1,2]),S,numclass,alpha04);
        [H_normalized4,gamma4,obj4] = mkkmeans_train(KH4,numclass,qnorm);
        res(:,5) = myNMIACC(H_normalized4,Y,numclass);
        
        %%%%%%%%---Average---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [H_normalized5,gamma5,obj5,KH5] = myabsentmultikernelclustering(KH(:,:,[1,2]),S,numclass,qnorm);
        res(:,6) = myNMIACC(H_normalized5,Y,numclass);
   
        save([path,'work2016\rebuttalExperiments\rebuttalResults\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res');
    end
end
