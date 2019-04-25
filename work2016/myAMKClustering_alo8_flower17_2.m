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
qnorm = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = [0.6:0.1:0.9];
for ie =1:length(epsionset)
    for iter = 1:1
        load([path,'work2016/generateAbsentMatrix/',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        algorithm_choose8 = 'algorithm2';
        lambdaset8 = 2.^[-15:2:9];
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
        alignment(8) = max(algval8);
        
        save([path,'work2016/myAbsentMKCres1/',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_alg8_iter_',num2str(iter),'.mat'],'res','alignment','obj8');
    end
end
