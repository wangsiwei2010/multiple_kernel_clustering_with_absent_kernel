clear
clc
warning off;

path = '/media/xinwang/软件/myWork/work2015/';
dataName = 'wisconsin'; %%%caltech101_10base; flower17; flower102; psortPos; CCV;
%% cornell; texas; washington; wisconsin
addpath(genpath(path));
load([path,'datasets/',dataName,'_features.mat'],'Xf1','Xf2','Xf3','Xf4','Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numclass = length(unique(Y));
num = length(Y);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KH = kcenter(KH);
% KH = knorm(KH);

qnorm = 2;
epsionset = [0.8:0.1:0.9];
for ie =1:length(epsionset)
    for iter = 1:50
        load([path,'work2016/generateAbsentMatrix/',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        obs_view1 = setdiff(1:num,S{1}.indx);
        obs_view2 = setdiff(1:num,S{2}.indx);
        obs_view1andview2 = intersect(obs_view1,obs_view2);
        obs_view1notview2 = setdiff(obs_view1,obs_view2);
        obs_view2notview1 = setdiff(obs_view2,obs_view1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        xpaired = Xf1(obs_view1andview2,:);
        ypaired = Xf2(obs_view1andview2,:);
        xsingle = Xf1(obs_view1notview2,:);
        ysingle = Xf2(obs_view2notview1,:);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH = zeros(num,num,2);
        KH(:,:,1)= mysvmkernel(Xf1,Xf1,'linear');
        KH(:,:,2)= mysvmkernel(Xf2,Xf2,'linear');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
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
        alpha05 = 1e-3;
        KH5 = algorithm4(KH,S,numclass,alpha05);
        [H_normalized5,gamma5,obj5] = mkkmeans_train(KH5,numclass,qnorm);
        res(:,5) = myNMIACC(H_normalized5,Y,numclass);
        
        %%%%%%%%--Initialization with Zero---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        algorithm_chosen1 = 'algorithm2';
        [H_normalized6,gamma6,obj6,KH6] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_chosen1);
        res(:,6) = myNMIACC(H_normalized6,Y,numclass);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%----Initialization with mean---%%%%%%%%%%%%%%%%%%%%
        algorithm_chosen2 = 'algorithm3';
        [H_normalized7,gamma7,obj7,KH7] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_chosen2);
        res(:,7) = myNMIACC(H_normalized7,Y,numclass);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             
        %%%%%%%%%%%%%----Initialization with knn---%%%%%%%%%%%%%%%%%%%%
        algorithm_chosen3 = 'algorithm0';
        [H_normalized8,gamma8,obj8,KH8] = myabsentmultikernelclustering(KH,S,numclass,qnorm,algorithm_chosen3);
        res(:,8) = myNMIACC(H_normalized8,Y,numclass);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        algorithm_chosen4 = 'algorithm2';
        numker = size(KH,3);
        lambdaset9 = 2.^[-15:1:9];
        accval9 = zeros(length(lambdaset9),1);
        nmival9 = zeros(length(lambdaset9),1);
        purval9 = zeros(length(lambdaset9),1);
        algval9 = zeros(length(lambdaset9),1);
        for il =1:length(lambdaset9)
            [H_normalized9,gamma9,obj9,KH9] = myamkcwithlambda(KH,S,numclass,qnorm,algorithm_chosen4,lambdaset9(il));
            res9 = myNMIACC(H_normalized9,Y,numclass);
            accval9(il) = res9(1);
            nmival9(il) = res9(2);
            purval9(il) = res9(3);
            algval9(il) = calKernelAlignment(KH,KH9)'*gamma9;
        end
        res(:,9) = [max(accval9); max(nmival9); max(purval9)];
        
        alignment(1) = calKernelAlignment(KH,KH1)'*gamma1;
        alignment(2) = calKernelAlignment(KH,KH2)'*gamma2;
        alignment(3) = calKernelAlignment(KH,KH3)'*gamma3;
        % alignment(4) = calKernelAlignment(KH,KH4)'*gamma4;
        alignment(5) = calKernelAlignment(KH,KH5)'*gamma5;
        alignment(6) = calKernelAlignment(KH,KH6)'*gamma6;
        alignment(7) = calKernelAlignment(KH,KH7)'*gamma7;
        alignment(8) = calKernelAlignment(KH,KH8)'*gamma8;
        alignment(9) = max(algval9);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        lambdaset10 = 1e-2;
        accval10 = zeros(length(lambdaset10),1);
        nmival10 = zeros(length(lambdaset10),1);
        purval10 = zeros(length(lambdaset10),1);
        for il =1:length(lambdaset10)
            H_normalized10 = myPVCclust(xpaired,ypaired,xsingle,ysingle,numclass,lambdaset10(il));
            res10 = myNMIACC(H_normalized10,Y,numclass);
            accval10(il) = res10(1);
            nmival10(il) = res10(2);
            purval10(il) = res10(3);
        end
        res(:,10) = [max(accval10); max(nmival10); max(purval10)];
        
        save([path,'work2016/webKB/',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','alignment','Y');
    end
end
