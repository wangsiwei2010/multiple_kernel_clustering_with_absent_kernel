clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'cornell';
%% cornell; texas; washington; wisconsin
load([path,'datasets\',dataName,'_Kmatrix.mat'],'KH','Y','Xf');
epsionset = [0.1:0.1:0.9];
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
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [H_normalized2,gamma2,obj2,KH2] = myabsentmultikernelclustering(KH,S,numclass,qnorm);
        res(:,2) = myNMIACC(H_normalized2,Y,numclass);

        save([path,'work2016\rebuttalExperiments\rebuttalResults\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res');
    end
end
