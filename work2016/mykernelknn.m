function  ypred = mykernelknn(Ktsttrn,gamma,Ytrn,k,qnorm)

KC  = mycombFun(Ktsttrn,gamma.^qnorm);
numtst = size(KC,1);
ypred = zeros(numtst,1);
for it =1:numtst
    sim_it = KC(it,:);
    [val,indx] = sort(sim_it,'descend');
    indx_topk = indx(1:k);
    it_labset = Ytrn(indx_topk);
    labset = unique(it_labset);
    num0 = zeros(length(labset),1);
    for ic =1:length(labset)
        num0(ic) = length(find(it_labset==labset(ic)));
    end
    indx0 = find(num0==max(num0));
    ypred(it) = labset(indx0(1));
end