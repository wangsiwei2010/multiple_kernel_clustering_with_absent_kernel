function X_imputed = zero_filling(X,S)

[num,dim]= size(X);
X_imputed = zeros(num,dim);
for p =1:dim
    indx_abs = setdiff(1:num,S{p}.indx');
    X_imputed(indx_abs,p) = X(indx_abs,p);
end