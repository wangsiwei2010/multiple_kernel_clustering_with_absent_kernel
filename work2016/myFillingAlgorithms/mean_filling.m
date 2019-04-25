function X_imputed = mean_filling(X,S)

[num,dim]= size(X);
X_imputed = zeros(num,dim);
for p =1:dim
    indx_obs = setdiff(1:num,S{p}.indx');
    X_imputed(indx_obs,p) = X(indx_obs,p);
    X_imputed(S{p}.indx',p) = mean(X_imputed(indx_obs,p));
end