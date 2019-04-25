clear
clc;
clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'flower17'; %%%caltech101_10base; flower17; flower102; psortPos; CCV;
epsionset = [0.9:0.1:0.9];
qnorm = 2;
C = 100;
class_ratio = 0.8;
for ie =1:length(epsionset)
    for iter = 1:1
        load([path,'work2016\myAbsentMKCres\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
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
%         KH1 = kcenter(KH1);
%         KH1 = knorm(KH1);
        Ktrntrn1 = KH1(trnindx,trnindx,:);
        Ktsttrn1 = KH1(tstindx,trnindx,:);
        [Alpsup1,w01,nbsv1,pos1,obj1] = mySVMmulticlassoneagainstall(Ytrn,C,Ktrntrn1,gamma);
        [ypred1,label1]= mymultival(Alpsup1,w01,pos1,nbsv1,Ktsttrn1,gamma);
        acc(iter,1) = mean(Ytst==label1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         KH2 = kcenter(KH2);
%         KH2 = knorm(KH2);
        Ktrntrn2 = KH2(trnindx,trnindx,:);
        Ktsttrn2 = KH2(tstindx,trnindx,:);
        [Alpsup2,w02,nbsv2,pos2,obj2] = mySVMmulticlassoneagainstall(Ytrn,C,Ktrntrn2,gamma);
        [ypred2,label2]= mymultival(Alpsup2,w02,pos2,nbsv2,Ktsttrn2,gamma);
        acc(iter,2) = mean(Ytst==label2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         KH3 = kcenter(KH3);
%         KH3 = knorm(KH3);
        Ktrntrn3 = KH3(trnindx,trnindx,:);
        Ktsttrn3 = KH3(tstindx,trnindx,:);
        [Alpsup3,w03,nbsv3,pos3,obj3] = mySVMmulticlassoneagainstall(Ytrn,C,Ktrntrn3,gamma);
        [ypred3,label3]= mymultival(Alpsup3,w03,pos3,nbsv3,Ktsttrn3,gamma);
        acc(iter,3) = mean(Ytst==label3);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         KH4 = kcenter(KH4);
%         KH4 = knorm(KH4);
        Ktrntrn4 = KH4(trnindx,trnindx,:);
        Ktsttrn4 = KH4(tstindx,trnindx,:);
        [Alpsup4,w04,nbsv4,pos4,obj4] = mySVMmulticlassoneagainstall(Ytrn,C,Ktrntrn4,gamma);
        [ypred4,label4]= mymultival(Alpsup4,w04,pos4,nbsv4,Ktsttrn4,gamma);
        acc(iter,4) = mean(Ytst==label4);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         KH5 = kcenter(KH5);
%         KH5 = knorm(KH5);
        Ktrntrn5 = KH5(trnindx,trnindx,:);
        Ktsttrn5 = KH5(tstindx,trnindx,:);
        [Alpsup5,w05,nbsv5,pos5,obj5] = mySVMmulticlassoneagainstall(Ytrn,C,Ktrntrn5,gamma);
        [ypred5,label5]= mymultival(Alpsup5,w05,pos5,nbsv5,Ktsttrn5,gamma);
        acc(iter,5) = mean(Ytst==label5);
        
    end
end