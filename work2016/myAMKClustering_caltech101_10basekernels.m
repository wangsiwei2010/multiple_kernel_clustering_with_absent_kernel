clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'caltech101_10base'; %%% ucsd-mit_caltech-101-mkl; flower17; YALE; flower102; plant

addpath(genpath(path));
%% load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
load([path,'datasets\',dataName,'_Kmatrix'],'Ktrntrn','Ytrn');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = Ktrntrn;
Y = Ytrn;
clear Ktrntrn Ytrn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = kcenter(KH);
KH = knorm(KH);
numclass = length(unique(Y));
numker = size(KH,3);
num = size(KH,1);
epsionset = [0.1:0.1:0.4];
for ie =1:length(epsionset)
    for iter =1:10
        load([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        %%%%%%%%%%%--Zero-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH1 = algorithm2(KH,S);
        H_normalized1 = mkkmeans_train(KH1,numclass);
        res(:,1) = myNMIACC(H_normalized1,Y,numclass);
        
        %%%%%%%%%%%--mean-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH2 = algorithm3(KH,S);
        H_normalized2 = mkkmeans_train(KH2,numclass);
        res(:,2) = myNMIACC(H_normalized2,Y,numclass);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH3 = algorithm4(KH,S,numclass);
        H_normalized3 = mkkmeans_train(KH3,numclass);
        res(:,3) = myNMIACC(H_normalized3,Y,numclass);
        
        %%%%%%%%---Average---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        lambdaset4 = 2.^[5:2:15];
        accval4 = zeros(length(lambdaset4),1);
        nmival4 = zeros(length(lambdaset4),1);
        purval4 = zeros(length(lambdaset4),1);
        for il =1:length(lambdaset4)
            [H_normalized4,gamma4,obj4] = myabsentmultikernelclustering(KH,S,numclass,lambdaset4(il));
            res4 = myNMIACC(H_normalized4,Y,numclass);
            accval4(il) = res4(1);
            nmival4(il) = res4(2);
            purval4(il) = res4(3);
        end
        res(:,4) = [max(accval4);max(nmival4);max(purval4)];
        save([path,'work2016\myAbsentMKCres\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_clustering_iter_',...
            num2str(iter),'.mat'],'res');
    end
end