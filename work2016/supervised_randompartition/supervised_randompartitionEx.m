clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'Reuters'; %%%caltech101_10base; flower17; flower102; CCV; caltech101_numofbasekernel_10
load([path,'datasets\',dataName,'_Kmatrix'],'Y');
iter = 1;
class_ratio = 0.6;
S = generaterandompartition(path,dataName,Y,class_ratio,iter);