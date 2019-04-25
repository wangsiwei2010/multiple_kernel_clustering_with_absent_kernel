function S = generateMissingIndex_UCI(path,dataName,num,dim,Y,class_ratio)

numker = dim;
for iter =1 : 50
    missingMatrix = ones(num,numker);
    classid = unique(Y);
    numclass = length(classid);
    for ic =1:numclass
        indxic = find(Y==classid(ic));
        lenic = length(indxic);
        randic = randperm(lenic);
        len_ic = round(class_ratio*lenic);
        indxicsel = indxic(randic(1:len_ic));
        for in = 1:len_ic
            % epsion0 = rand;
            epsion0 = 0.5;
            randi = rand(numker,1);
            %             [val,indxicin] = sort(randi,'ascend');
            %             indx0 = indxicin(1:floor(numker*epsion0));
            indx0 = find(randi<epsion0);
            if isempty(indx0)
                randi = rand(numker,1);
                indx0 = find(randi<epsion0);
            end
            missingMatrix(indxicsel(in),indx0)=0;
        end
    end
    for p =1:numker
        S{p}.indx = find(missingMatrix(:,p)==0)';
    end
    save([path,'work2016\generateAbsentMatrix\',dataName,'_missingRatio_',num2str(class_ratio),...
        '_missingIndex_iter_',num2str(iter),'.mat'],'S');
end