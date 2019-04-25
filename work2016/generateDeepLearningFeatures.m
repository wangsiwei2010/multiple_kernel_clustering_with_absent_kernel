clc
clf
warning off;

path = 'D:\myWork\work2015\';
addpath(genpath(path));
dataName = 'facerecognition'; %%%flower17; flower102; CCV; caltech101_numofbasekernel_10; bbcsport2view
load([path,dataName,'.mat'],'featMat_7','labels');
[dim1,dim2,numker,numsam]= size(featMat_7);
multiFeature = zeros(numsam,dim1*dim2,numker);
for i =1:numsam
    for p =1:numker
        multiFeature(i,:,p) = reshape(featMat_7(:,:,p,i),dim1*dim2,1);
    end
end

Y = labels;
cindx = unique(Y);
indx_sel = [];
for ic =1:length(cindx)
    indxic = find(cindx(ic)==Y);
    indx_sel = [indx_sel indxic(1:20)];
end
multiFeature0 = multiFeature(indx_sel,:,:);
Y0 = Y(indx_sel);
clear multiFeature Y

multiFeature = multiFeature0;
Y = double(Y0)';
clear multiFeature0 Y0
numsam = size(multiFeature,1);
numker = 20;
KH = zeros(numsam,numsam,numker);
for p =1:numker
    KH(:,:,p) = mysvmkernel(multiFeature(:,:,p),multiFeature(:,:,p),'Gaussian');
end
save([path,'datasets\',dataName,'_numOfSamples_',num2str(numsam),'_numOfKernels_',num2str(numker),...
    '_Kmatrix.mat'],'KH','Y');