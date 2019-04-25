clear ;
clc;
figure(1);
cxd = rand(10,6)*0.8;  
h2=plot(cxd);
set(h2(1),'LineStyle','-','LineWidth',2,'Color','b','Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',5)
set(h2(2),'LineStyle','-','LineWidth',2,'Color','m','Marker','o','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',5)
set(h2(3),'LineStyle','-','LineWidth',2,'Color','r','Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',5)
set(h2(4),'LineStyle','-','LineWidth',2,'Color','c','Marker','o','MarkerEdgeColor','c','MarkerFaceColor','c','MarkerSize',5)
set(h2(5),'LineStyle','-','LineWidth',2,'Color','k','Marker','o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
set(h2(6),'LineStyle','-','LineWidth',2,'Color','g','Marker','o','MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',5)
hold on


x=[[1 1  4 4  7 7 ]+0.5;[1 1  4 4  7 7 ]+1.5];
y=[[9 8  9 8  9 8 ]./10+0.05;[9 8  9 8  9 8 ]./10+0.05];
h3=plot(x,y);
set(h3(1),'LineStyle','-','LineWidth',2,'Color','b')
set(h3(2),'LineStyle','-','LineWidth',2,'Color','m')
set(h3(3),'LineStyle','-','LineWidth',2,'Color','r')
set(h3(4),'LineStyle','-','LineWidth',2,'Color','c')
set(h3(5),'LineStyle','-','LineWidth',2,'Color','k')
set(h3(6),'LineStyle','-','LineWidth',2,'Color','g')

hold on
x1=[[1 1  4 4  7 7 ]+1;[1 1  4 4  7 7 ]+1];
y1=[[9 8  9 8  9 8 ]./10+0.05;[9 8  9 8  9 8 ]./10+0.05];
h4=plot(x1,y1);
set(h4(1),'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',5)
set(h4(2),'Marker','o','MarkerEdgeColor','m','MarkerFaceColor','m','MarkerSize',5)
set(h4(3),'Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',5)
set(h4(4),'Marker','o','MarkerEdgeColor','c','MarkerFaceColor','c','MarkerSize',5)
set(h4(5),'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',5)
set(h4(6),'Marker','o','MarkerEdgeColor','g','MarkerFaceColor','g','MarkerSize',5)

legends={'cxd1','cxd2','cxd3','cxd4','cxd5','cxd6'};
tx=[1 1  4 4  7 7 ]+1.8;
ty=[9 8  9 8  9 8 ]./10+0.05;
for i=1:6
    text(tx(i),ty(i),legends{i});
end 
xlim([1,10]);ylim([0,1]);
xlabel('x');
ylabel('y');
title('legend Test');
grid on;
box off;