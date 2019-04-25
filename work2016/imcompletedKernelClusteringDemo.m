clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'flower17'; %%% ucsd-mit_caltech-101-mkl; flower17

addpath(genpath(path));
load([path,'datasets\',dataName,'_Kmatrix'],'KH','Y');
num = 10;
Kx = KH(1:num,1:num,1);
Ky = KH(1:num,1:num,2);
num = size(Kx,1);
num0 = 3;
indx_rand = randperm(num);
missing = indx_rand(1:num0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S1{1}.indx = missing;
Ky_zero = algorithm2(Ky,S1);
Ky_mean = algorithm3(Ky,S1);
alpha0 = 1e-3;
% Ky_alig = algorithm4(Ky,S1,alpha0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ky_knn0 = Ky;
Ky_knn0(S1{1}.indx,S1{1}.indx) = nan;
Ky_knn = DataCompletion(Ky_knn0, 'KNN');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ky_em0 = Ky;
Ky_em0(S1{1}.indx,S1{1}.indx) = nan;
Ky_em = DataCompletion(Ky_em0, 'EM');

obs_indx = setdiff(1:num,S1{1}.indx);
Kycc = Ky(obs_indx,obs_indx);
[Kyr3] = absentKernelImputation(Kx,Kycc,missing,5e-2);