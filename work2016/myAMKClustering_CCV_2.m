clear
clc
warning off;

path = '/media/xinwang/软件/myWork/work2015/';
addpath(genpath(path));
dataName = 'flower17'; %%% flower17; flower102; CCV; caltech101_numofbasekernel_10; caltech101_mit
%% %% washington; wisconsin; texas; cornell
load([path,'datasets/',dataName,'_Kmatrix'],'KH','Y');
% load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
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
epsionset = [0.9:0.1:0.9];
for ie =1:length(epsionset)
    for iter = 1:30
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
        algorithm_choose1 = 'algorithm2';
        [H_normalized5,gamma5,obj5,KH5] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_choose1);
        res(:,5) = myNMIACC(H_normalized5,Y,numclass);
        
        algorithm_choose2 = 'algorithm3';
        [H_normalized6,gamma6,obj6,KH6] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_choose2);
        res(:,6) = myNMIACC(H_normalized6,Y,numclass);
        
        algorithm_choose3 = 'algorithm0';
        [H_normalized7,gamma7,obj7,KH7] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_choose3);
        res(:,7) = myNMIACC(H_normalized7,Y,numclass);
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        algorithm_choose8 = 'algorithm2';
        lambdaset8 = 1/numker;
        accval8 = zeros(length(lambdaset8),1);
        nmival8 = zeros(length(lambdaset8),1);
        purval8 = zeros(length(lambdaset8),1);
        algval8 = zeros(length(lambdaset8),1);
        for il =1:length(lambdaset8)
            [H_normalized8,gamma8,obj8,KH8] = myamkcwithlambda(KH,S,numclass,qnorm,algorithm_choose8,lambdaset8(il));
            res8 = myNMIACC(H_normalized8,Y,numclass);
            accval8(il) = res8(1);
            nmival8(il) = res8(2);
            purval8(il) = res8(3);
            algval8(il) = calKernelAlignment(KH,KH8)'*gamma8;
        end
        res(:,8) = [max(accval8); max(nmival8); max(purval8)];
        
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         algorithm_choose9 = 'algorithm2';
%         lambdaset9 = 1/numker;
%         accval9 = zeros(length(lambdaset9),1);
%         nmival9 = zeros(length(lambdaset9),1);
%         purval9 = zeros(length(lambdaset9),1);
%         algval9 = zeros(length(lambdaset9),1);
%         for il =1:length(lambdaset9)
%             [H_normalized9,gamma9,obj9,KH9] = myamkcwithlambdaV2(KH,S,numclass,qnorm,algorithm_choose9,lambdaset9(il));
%             res9 = myNMIACC(H_normalized9,Y,numclass);
%             accval9(il) = res9(1);
%             nmival9(il) = res9(2);
%             purval9(il) = res9(3);
%             algval9(il) = calKernelAlignment(KH,KH9)'*gamma9;
%         end
%         res(:,9) = [max(accval9); max(nmival9); max(purval9)];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        alignment(1) = calKernelAlignment(KH,KH1)'*gamma1;
        alignment(2) = calKernelAlignment(KH,KH2)'*gamma2;
        alignment(3) = calKernelAlignment(KH,KH3)'*gamma3;
        alignment(4) = calKernelAlignment(KH,KH4)'*gamma4;
        alignment(5) = calKernelAlignment(KH,KH5)'*gamma5;
        alignment(6) = calKernelAlignment(KH,KH6)'*gamma6;
        alignment(7) = calKernelAlignment(KH,KH7)'*gamma7;
        alignment(8) = max(algval8);
        
        save([path,'work2016/myAbsentMKCres1/',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','res_gnd','alignment');
    end
end