clear, 
clc;
addpath(genpath('D:\myWork\work2015\work2016\DataCompletion\'));
% This is a toy example for using the missing value estimation package.
% 

% Always remember to add the path :-)
addpath('./imputation');

n = 5;

X = rand(n);
ind = randperm(n^2);

X(ind(1:n)) = nan;

disp('Before completion:');
disp(X);

Method = 'EM';
X0 = DataCompletion(X, Method);

disp('After completion:');
disp(X0);