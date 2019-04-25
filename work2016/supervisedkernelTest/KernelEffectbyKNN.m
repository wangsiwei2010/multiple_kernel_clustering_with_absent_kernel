clear
clc;
clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'Reuters'; %%%caltech101_10base; flower17; flower102; psortPos; CCV;
epsionset = [0.1:0.1:0.4];
qnorm = 2;
class_ratio = 0.6;
k = 11;
for ie =1:length(epsionset)
    for iter = 1:1
        load([path,'work2016\myAbsentMKCres1\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','gamma1','gamma2','gamma3','gamma4','gamma5',...
            'KH1','KH2','KH3','KH4','KH5','Y');
        
        load([path,'work2016\supervised_randompartition\',dataName,'_missingRatio_',num2str(class_ratio),...
            '_missingIndex_iter_',num2str(iter),'.mat'],'S');
        trnindx = find(S==1);
        tstindx = find(S==-1);
        numker = size(KH1,3);
        gamma = ones(numker,1)/numker;
        Ytrn = Y(trnindx);
        Ytst = Y(tstindx);
  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ktsttrn1 = KH1(tstindx,trnindx,:);
        ypred1 = mykernelknn(Ktsttrn1,gamma1,Ytrn,k,qnorm);
        acc(iter,1) = mean(ypred1==Ytst);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ktsttrn2 = KH2(tstindx,trnindx,:);
        ypred2 = mykernelknn(Ktsttrn2,gamma2,Ytrn,k,qnorm);
        acc(iter,2) = mean(ypred2==Ytst);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ktsttrn3 = KH3(tstindx,trnindx,:);
        ypred3 = mykernelknn(Ktsttrn3,gamma3,Ytrn,k,qnorm);
        acc(iter,3) = mean(ypred3==Ytst);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ktsttrn4 = KH4(tstindx,trnindx,:);
        ypred4 = mykernelknn(Ktsttrn4,gamma4,Ytrn,k,qnorm);
        acc(iter,4) = mean(ypred4==Ytst);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Ktsttrn5 = KH5(tstindx,trnindx,:);
        ypred5 = mykernelknn(Ktsttrn5,gamma5,Ytrn,k,qnorm);
        acc(iter,5) = mean(ypred5==Ytst);
    end
end