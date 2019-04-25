function [obj]= calObjwithlambda(K,obj1,lambda)

nbkernel = size(K,3);
obj2 = 0;
for p = 1 : nbkernel
    obj2 = obj2 + trace(K(:,:,p)*K(:,:,p));
end
obj = 2*obj1+lambda*obj2;