clear
clc
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'plant'; %%%caltech101_10base; flower17; flower102; CCV; caltech101_numofbasekernel_10
%% bbcsport2view
numofKernel = 10;
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
numclass = length(unique(Y));
indeset = [];
num0 = zeros(numclass,1);
for ic = 1 : numclass
    indxc = find(Y==ic);
    num0(ic) = length(indxc);
    indeset = [indeset;indxc];
end
KH = KH(indeset,indeset,:);
Y = Y(indeset);
save([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');