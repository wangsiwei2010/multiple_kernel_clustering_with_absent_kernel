function K = mykernelimputation(K0,Kcc,obs_indx)

% num = size(K0,1);
% cvx_begin sdp
%     variable K(num,num)
%     minimize(norm(K-K0,'fro'));
%     subject to
%     K(obs_indx,obs_indx)==Kcc;
%     K==semidefinite(num);
% cvx_end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = K0;
K(obs_indx,obs_indx) = Kcc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = (K +K')/2;
[Um,Vm] = eig(K);
diagVm = diag(Vm);
diagVm(diagVm<1e-10)=0;
K = Um*diag(diagVm)*Um';
K = (K+K')/2;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% num = size(K0,1);
% mis_indx = setdiff(1:num,obs_indx);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kmm = K0(mis_indx,mis_indx);
% Kmm = (Kmm + Kmm')/2;
% [Um,Vm] = eig(Kmm);
% diagVm = diag(Vm);
% diagVm(diagVm<1e-6)=0;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% K = K0;
% K(obs_indx,obs_indx) = Kcc;
% K(mis_indx,mis_indx) = Um*diag(diagVm)*Um' + 1e-1*eye(length(mis_indx));
% K = (K+K')/2;