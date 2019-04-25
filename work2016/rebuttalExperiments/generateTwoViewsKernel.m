clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'cornell'; %%% flower17; flower102; CCV; caltech101_numofbasekernel_10
%% cornell; texas; washington; wisconsin
load([path,'sourceDaya\WebKB\',dataName,'.mat'],'cites','content','label');
Y = label;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X1 = cites;
X2 = content;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim1 = size(X1,2);
std1 = std(X1);
indx1 = find(std1<1e-5);
indxuse1 = setdiff([1:dim1],indx1);
X1 = X1(:,indxuse1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dim2 = size(X2,2);
std2 = std(X2);
indx2 = find(std2<1e-5);
indxuse2 = setdiff([1:dim2],indx2);
X2 = X2(:,indxuse2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Xf{1}.feature = X1;
Xf{2}.feature = X2;
num = length(Y);
KH = zeros(num,num,2);
KH(:,:,1) = mysvmkernel(X1,X1,'poly',2);
KH(:,:,2) = mysvmkernel(X2,X2,'poly',2);
save([path,'datasets\',dataName,'_Kmatrix.mat'],'KH','Y','Xf','-v7.3');