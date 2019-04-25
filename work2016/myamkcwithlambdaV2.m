function [H_normalized,gamma,obj,KA] = myamkcwithlambdaV2(K,S,cluster_count,qnorm,algorithm_choose,lambda)

num = size(K,1);
nbkernel = size(K,3);
%% S: num0*m, each column indicates the indices of absent samples
%% initialize kernel weights
gamma = ones(nbkernel,1)/nbkernel;
%% initialize base kernels with zeros
if strcmp(algorithm_choose,'algorithm0')
    KA = feval(algorithm_choose,K,S,7);
else
    KA = feval(algorithm_choose,K,S);
end
%% combining the base kernels
KC  = mycombFun(KA,gamma.^qnorm);
flag = 1;
iter = 0;
while flag
    iter = iter + 1;
    fprintf(1, 'running iteration of our proposed algorithm %d...\n', iter);
    %% update H with KC
    H = mykernelkmeans(KC,cluster_count);
   %% updata base kernels
    KA = zeros(num,num,nbkernel);
    for p =1:nbkernel
        if isempty(S{p}.indx)
             KA(:,:,p) = K(:,:,p);
        else 
            Kxp = calKxV2(gamma,KA,H,lambda,p);
            obs_indexp = setdiff(1:num,S{p}.indx);
            %% K = mykernelimputation(K0,Kcc,obs_indx)
            %% KA(:,:,p) = mykernelimputation(Kxp,K(obs_indexp,obs_indexp,p),obs_indexp);
            KA(:,:,p) = absentKernelImputation(Kxp,K(obs_indexp,obs_indexp,p),S{p}.indx,1e-3);
        end
    end
    %% update kernel weights
    M = calM(KA);
    [gamma,obj2] = updateAMKwithlambdaV2(H,KA,M,lambda);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% [obj]= calObjwithlambdaV2(K,M,gamma,H,lambda)
    obj(iter) = calObjwithlambdaV2(KA,M,gamma,H,lambda);
    %% KC  = mycombFun(KA,gamma.^qnorm);
    KC  = mycombFun(KA,gamma.^qnorm);
    if iter>2 && (abs((obj(iter-1)-obj(iter))/(obj(iter-1)))<1e-3 ||iter>10)
        flag =0;
    end
end
H_normalized = H./ repmat(sqrt(sum(H.^2, 2)), 1,cluster_count);