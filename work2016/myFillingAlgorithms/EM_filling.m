function X_imputed = EM_filling(X,S)

[num, numker] = size(X);
for p =1:numker
    %% index_absent = setdiff(1:num,S{p}.indx');
    X(S{p}.indx',p) = nan;
end
X_imputed = DataCompletion(X,'EM');