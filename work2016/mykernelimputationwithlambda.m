function Kyr = mykernelimputationwithlambda(K0,Kcc,obs_indx)

mis_indx = setdiff(1:size(K0,1),obs_indx);
[Kyr]= absentKernelImputation(K0,Kcc,mis_indx,1e-6);