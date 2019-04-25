function S = generaterandompartition(path,dataName,Y,class_ratio,iter)

classid = unique(Y);
numclass = length(classid);
num = length(Y);
S = -ones(num,1);
for ic =1:numclass
    indxic = find(Y==classid(ic));
    lenic = length(indxic);
    randic = randperm(lenic);
    len_ic = round(class_ratio*lenic);
    indxicsel = indxic(randic(1:len_ic));
    S(indxicsel) = 1;
end
save([path,'work2016\supervised_randompartition\',dataName,'_missingRatio_',num2str(class_ratio),...
    '_missingIndex_iter_',num2str(iter),'.mat'],'S');