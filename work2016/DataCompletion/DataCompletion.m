function X = DataCompletion(X, Method)
% Matrix completion using different method
% 2 Methods are included: KNN and EM
% The missing values must be marked as NaN.
% 

if ~any(isnan(X))
    error('The missing values should be marked as NaN in the input matrix.');
end

switch Method
    case 'KNN'
        X = knnimpute(X);
    case 'EM'
        X = regem(X);
    otherwise
        error('Only KNN and EM is supported');
end