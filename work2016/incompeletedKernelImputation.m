function [Kyr]= incompeletedKernelImputation(Kx,Ky_obs,mis_indx)

%% m is the indices of missing samples.
n = size(Kx,1);
%% c is the indices of available samples.
obs_indx = setdiff(1:n,mis_indx);
%%
Kx0 = Kx([obs_indx,mis_indx],[obs_indx,mis_indx]);
Kycc = Ky_obs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dx = diag(sum(Kx0));
Lx = eye(n) - Dx\Kx0;
Lxmm = Lx(mis_indx,mis_indx);
Lxcm = Lx(obs_indx,mis_indx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Lxcmmm = -Lxcm/Lxmm;
Kycm = Kycc*Lxcmmm;
Kymm = Lxcmmm'*Kycm;
Kyr0 = [Kycc Kycm; Kycm' Kymm];
Kyr0 = (Kyr0+Kyr0')/2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[val,indxxx] = sort([mis_indx,obs_indx],'ascend');
Kyr=Kyr0(indxxx,indxxx);