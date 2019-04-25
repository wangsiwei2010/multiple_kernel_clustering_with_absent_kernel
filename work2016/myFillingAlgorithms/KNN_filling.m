function X_imputed = KNN_filling(X,S)

[num, numker] = size(X);
for p =1:numker
    X(S{p}.indx',p) = nan;
end
X_imputed = DataCompletion(X,'KNN');