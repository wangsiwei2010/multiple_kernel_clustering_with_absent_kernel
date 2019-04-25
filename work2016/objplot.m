clear
clc
warning off;

path = 'D:\myWork\work2015\';
dataName = 'flower102'; %%%caltech101_numofbasekernel_10; flower17; flower102; psortPos; CCV;
addpath(genpath(path));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
epsionset = 0.4;
qnorm = 2;
for ie =1:length(epsionset)
    for iter = 2
        load([path,'work2016\allRes\',dataName,'_missingRatio_',num2str(epsionset(ie)),'_norm_',num2str(qnorm),...
            '_clustering_iter_',num2str(iter),'.mat'],'res','gamma1','gamma2','gamma3','gamma4','gamma5','obj5',...
            'res_gnd','alignment');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure(1);
        plot(obj5,'-rs','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r',...
            'MarkerSize',6)
        hold on;
        title('\fontsize{16}{Flower102}')
        xlabel('\fontsize{16}{Number of iterations (with missing ratio=0.9)}');
        ylabel('\fontsize{16}{Objective Values}');
        grid on;
        axis normal
    end
end