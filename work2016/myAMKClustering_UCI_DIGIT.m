clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'flower17'; %%% ucsd-mit_caltech-101-mkl; flower17; YALE; flower102; plant

addpath(genpath(path));
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
KH = kcenter(KH);
KH = knorm(KH);
numclass = length(unique(Y));
numker = size(KH,3);
num = size(KH,1);
epsionset = [0.1:0.1:0.8];
for ie =1:length(epsionset)
    for iter =1:10
        load([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(epsionset(ie)),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        %%%%%%%%%%%--Zero-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH1 = algorithm2(KH,S);
        M1 = zeros(numker);
        for p =1:numker
            for q = p:numker
                M1(p,q) = trace(KH1(:,:,p)'*KH1(:,:,q));
            end
        end
        M1 = (M1+M1')-diag(diag(M1));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        lambdaset1 = 2.^[-5:2:9];
        accval1 = zeros(length(lambdaset1),1);
        nmival1 = zeros(length(lambdaset1),1);
        purval1 = zeros(length(lambdaset1),1);
        for il =1:length(lambdaset1)
            [H_normalized1,gamma1,obj1] = myregmultikernelclustering(KH1,numclass,M1,lambdaset1(il));
            res1 = myNMIACC(H_normalized1,Y,numclass);
            accval1(il) = res1(1);
            nmival1(il) = res1(2);
            purval1(il) = res1(3);
        end
        res(:,1) = [max(accval1);max(nmival1);max(purval1)];
        
        %%%%%%%%%%%--mean-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH2 = algorithm3(KH,S);
        M2 = zeros(numker);
        for p =1:numker
            for q = p:numker
                M2(p,q) = trace(KH2(:,:,p)'*KH2(:,:,q));
            end
        end
        M2 = (M2+M2')-diag(diag(M2));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        lambdaset2 = 2.^[-5:2:9];
        accval2 = zeros(length(lambdaset2),1);
        nmival2 = zeros(length(lambdaset2),1);
        purval2 = zeros(length(lambdaset2),1);
        for il =1:length(lambdaset2)
            [H_normalized2,gamma2,obj2] = myregmultikernelclustering(KH2,numclass,M2,lambdaset2(il));
            res2 = myNMIACC(H_normalized2,Y,numclass);
            accval2(il) = res2(1);
            nmival2(il) = res2(2);
            purval2(il) = res2(3);
        end
        res(:,2) = [max(accval2);max(nmival2);max(purval2)];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        KH3 = algorithm4(KH,S,numclass);
        M3 = zeros(numker);
        for p =1:numker
            for q = p:numker
                M3(p,q) = trace(KH3(:,:,p)'*KH3(:,:,q));
            end
        end
        M3 = (M3+M3')-diag(diag(M3));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        lambdaset3 = 2.^[-5:2:9];
        accval3 = zeros(length(lambdaset3),1);
        nmival3 = zeros(length(lambdaset3),1);
        purval3 = zeros(length(lambdaset3),1);
        for il =1:length(lambdaset3)
            [H_normalized3,gamma3,obj3] = myregmultikernelclustering(KH3,numclass,M3,lambdaset3(il));
            res3 = myNMIACC(H_normalized3,Y,numclass);
            accval3(il) = res3(1);
            nmival3(il) = res3(2);
            purval3(il) = res3(3);
        end
        res(:,3) = [max(accval3);max(nmival3);max(purval3)];
        
        %%%%%%%%---Average---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        lambdaset4 = 2.^[-5:2:9];
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
        save([path,'work2016\myAbsentMKCresV2\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_clustering_iter_',...
            num2str(iter),'.mat'],'res');
    end
end