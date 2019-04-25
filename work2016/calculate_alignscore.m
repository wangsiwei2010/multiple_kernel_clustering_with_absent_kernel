clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'flower17'; %%%Reuters
%% psortPos, psortNeg; plant; proteinFold
addpath(genpath(path));
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
numclass = length(unique(Y));
numker = size(KH,3);
KH = kcenter(KH);
KH = knorm(KH);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = [0.1:0.1:0.9];
qnorm = 2;
maxIter = 5;
for ie =1:length(epsionset)
    res_avg = zeros(maxIter,3,5);
    align_score = zeros(maxIter,5);
    for iter = 1 : maxIter       
        load([path,'work2016\myAbsentMKCres1\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','gamma1','gamma2','gamma3','gamma4','gamma5','obj5',...
            'KH1','KH2','KH3','KH4','KH5','Y');
        KH1 = kcenter(KH1);
        KH2 = kcenter(KH2);
        KH3 = kcenter(KH3);
        KH4 = kcenter(KH4);
        KH5 = kcenter(KH5);
        gamma0 = ones(numker,1)/numker;
        KC1  = mycombFun(KH1,gamma0.^qnorm);
        [U1] = mykernelkmeans(KC1,numclass);
        res_avg(iter,:,1) = myNMIACC(U1,Y,numclass);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        KC2  = mycombFun(KH2,gamma0.^qnorm);
        [U2] = mykernelkmeans(KC2,numclass);
        res_avg(iter,:,2) = myNMIACC(U2,Y,numclass);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%--knn-Filling--%%%%%%%%%%%%%%%%%%%%%%%%%%
        KC3  = mycombFun(KH3,gamma0.^qnorm);
        [U3] = mykernelkmeans(KC3,numclass);
        res_avg(iter,:,3) = myNMIACC(U3,Y,numclass);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        KC4  = mycombFun(KH4,gamma0.^qnorm);
        [U4] = mykernelkmeans(KC4,numclass);
        res_avg(iter,:,4) = myNMIACC(U4,Y,numclass);
        %%%%%%%%---Average---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        KC5  = mycombFun(KH5,gamma0.^qnorm);
        [U5] = mykernelkmeans(KC5,numclass);
        res_avg(iter,:,5) = myNMIACC(U5,Y,numclass);
        
        KC  = mycombFun(KH,gamma0.^qnorm);
        [U] = mykernelkmeans(KC,numclass);
        res_avg(iter,:,6) = myNMIACC(U,Y,numclass);
        
        align_score(iter,:) = [trace(KC*KC1')/sqrt(trace(KC*KC')*trace(KC1*KC1')), trace(KC*KC2')/sqrt(trace(KC*KC')*trace(KC2*KC2')),...
            trace(KC*KC3')/sqrt(trace(KC*KC')*trace(KC3*KC3')), trace(KC*KC4')/sqrt(trace(KC*KC')*trace(KC4*KC4')),...
            trace(KC*KC5')/sqrt(trace(KC*KC')*trace(KC5*KC5'))]
    end
    res1(ie,:) = mean(align_score);
end