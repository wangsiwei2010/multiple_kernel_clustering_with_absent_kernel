clear all;
clc;

addpath(genpath('measure/'));
addpath(genpath('misc/'));
addpath(genpath(('../code/')));

resdir='data/result/';
datasetdir='data/';
dataname={'cornell'};
num_views =2;
numClust = 5;

pairPortion=[0.1];
for idata=1:length(dataname)
    dataf=strcat(datasetdir,dataname(idata),'RnSp.mat');
    datafname=cell2mat(dataf(1));
    load (datafname);
    Xf1=readsparse(X1);
    Xf2=readsparse(X2);
    X{1} =Xf1;
    X{2} =Xf2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    num = size(Xf1,1);
    KH = zeros(num,num,2);
    KH(:,:,1)= mysvmkernel(Xf1,Xf1,'gaussian',-1);
    KH(:,:,2)= mysvmkernel(Xf2,Xf2,'gaussian',-1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    load(cell2mat(strcat(datasetdir,dataname(idata),'Folds.mat'))); % folds
    [numFold,numInst]=size(folds);
    dir=strcat(resdir,cell2mat(dataname(idata)),'/'); %    train_target(idnon)=-1;   ranksvm treat weak label {-1: -1; 1:+1; 0:-1}
    mkdir(dir);
    
    for f=1:1%numFold
        instanceIdx=folds(f,:);
        truthF=truth(instanceIdx);
        for v1=1:num_views
            for v2=v1+1:num_views
                if v1==v2
                    continue;
                end
                
                for pairedIdx=1:1%length(pairPortion) % different percentage of paired instances
                    numpairedInst=floor(numInst*pairPortion(pairedIdx));  % number of paired instances  have complete views
                    paired=instanceIdx(1:numpairedInst);
                    singledNumView1=ceil(0.5*(length(instanceIdx)-numpairedInst));
                    singleInstView1=instanceIdx(numpairedInst+1:numpairedInst+singledNumView1);   % the first view  and second view miss  half to half
                    singleInstView2=instanceIdx(numpairedInst+singledNumView1+1:end); %instanceIdx(numpairedInst+numsingleInstView1+1:end);
                    xpaired=X{v1}(paired,:);
                    ypaired=X{v2}(paired,:);
                    xsingle=X{v1}(singleInstView1,:);
                    ysingle=X{v2}(singleInstView2,:);
                    
                    lamda=1e-2;
                    H_normalized1 = myPVCclust(xpaired,ypaired,xsingle,ysingle,numClust,lamda);
                    res(:,1) = myNMIACC(H_normalized1,truthF,numClust);
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    SS{1}.indx = setdiff(1:num,union(paired,singleInstView1));
                    SS{2}.indx = setdiff(1:num,union(paired,singleInstView2));
                    qnorm = 2;
                    [H_normalized2,gamma2,obj2,KH2] = myabsentmultikernelclustering(KH,SS,numClust,qnorm);
                    res(:,2) = myNMIACC(H_normalized2,truthF,numClust);
%                     
                end
            end
        end
    end
end