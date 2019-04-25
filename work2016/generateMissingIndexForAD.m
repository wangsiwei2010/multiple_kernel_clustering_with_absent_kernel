function S = generateMissingIndexForAD(path,dataName,num,numker,Y,class_ratio,epsionset)

for iter =1 : 50
    for p =1:numker
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
                randi = rand(numker,1);
                [val,indxicin] = sort(randi,'ascend');
                indx0 = indxicin(1:floor(numker*epsionset(p)));
                %             indx0 = find(randi<epsion0);
                %             if isempty(indx0)
                %                 randi = rand(numker,1);
                %                 indx0 = find(randi<epsion0);
                %             end
                missingMatrix(indxicsel(in),indx0)=0;
            end
        end
        S{p}.indx = find(missingMatrix(:,p)==0)';
    end
    save([path,'work2016/generateAbsentMatrix/',dataName,'_missingRatio_',num2str(class_ratio),...
        '_missingIndex_iter_',num2str(iter),'.mat'],'S');
end