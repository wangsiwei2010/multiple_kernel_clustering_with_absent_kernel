clear
clc
warning off;

path = '/media/xinwang/软件/myWork/work2015/';
dataName = 'CCV'; %%%caltech101_numofbasekernel_10; flower17; flower102; psortPos; CCV;
%% psortPos, psortNeg; plant; proteinFold
addpath(genpath(path));
load([path,'datasets/',dataName,'_Kmatrix'],'KH','Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numclass = length(unique(Y));
numker = size(KH,3);
num = size(KH,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = kcenter(KH);
KH = knorm(KH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
qnorm = 2;
[H_normalized,gamma,obj] = mkkmeans_train(KH,numclass,qnorm);
res_gnd = myNMIACC(H_normalized,Y,numclass);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = [0.7:0.1:0.7];
for ie =1:length(epsionset)
    for iter = 7:8
        load([path,'work2016/generateAbsentMatrix/',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        
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
        alignment(:,1) = calKernelAlignment(KH,KH1);
        alignment(:,2) = calKernelAlignment(KH,KH2);
        alignment(:,3) = calKernelAlignment(KH,KH3);
        alignment(:,4) = calKernelAlignment(KH,KH4);
        alignment(:,5) = calKernelAlignment(KH,KH5);

        save([path,'work2016/myAbsentMKCres1/',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','gamma1','gamma2','gamma3','gamma4','gamma5','obj5',...
            'res_gnd','alignment');
    end
end
