cont1qupair(1,:) = [9.5508e-04,4.6277e-04]
cont1qupair(2,:) = [-0.0020,0.0014       ]
cont1qupair(3,:) = [-0.0023,0.0021       ]
cont1qupair(4,:) = [-0.0021,0.0025       ]
cont1qupair(5,:) = [-9.9241e-05,0.0034   ]

cont2qupair(1,:) = [7.8158e-04,3.8179e-04]
cont2qupair(2,:) = [-0.0017,0.0014       ]
cont2qupair(3,:) = [2.0255e-04,0.0044    ]
cont2qupair(4,:) = [-0.0011,0.0036       ]
cont2qupair(5,:) = [-0.0041,2.4105e-04   ]

cont1qupair_err(1,:) = [2.7436e-04,2.6484e-04]
cont1qupair_err(2,:) = [3.0663e-04,2.8842e-04]
cont1qupair_err(3,:) = [6.7365e-04,6.6340e-04]
cont1qupair_err(4,:) = [5.3303e-04,5.4699e-04]
cont1qupair_err(5,:) = [8.7406e-04,8.7468e-04]

cont2qupair_err(1,:) = [3.6865e-04,3.7711e-04]
cont2qupair_err(2,:) = [4.4522e-04,4.1554e-04]
cont2qupair_err(3,:) = [9.6309e-04,8.8501e-04]
cont2qupair_err(4,:) = [6.6748e-04,7.7754e-04]
cont2qupair_err(5,:) = [0.0012,0.0012]




plottingqupair = figure
set(gcf,'color','w');
set(plottingqupair,'units','normalized','outerposition',[0 0 1 1]);
set(plottingqupair,'PaperUnits','normalized','PaperPosition',[0 0 3 1]);
set(gcf,'renderer','painters')
colormap jet

clf
axis([[-0.5 0.5] [-0.5 0.5]])
hold all
plot(100*cont1qupair(:,1),100*cont1qupair(:,2),'Color','black')
e1 = errorbar(100*cont1qupair(1,1),100*cont1qupair(1,2),100*cont1qupair_err(1,2),100*cont1qupair_err(1,2),100*cont1qupair_err(1,1),100*cont1qupair_err(1,1),'Color','black','Marker','x','MarkerSize',5)                              
e2 = errorbar(100*cont1qupair(2,1),100*cont1qupair(2,2),100*cont1qupair_err(2,2),100*cont1qupair_err(2,2),100*cont1qupair_err(2,1),100*cont1qupair_err(2,1),'Color','black','Marker','s','MarkerSize',5)                                  
e3 = errorbar(100*cont1qupair(3,1),100*cont1qupair(3,2),100*cont1qupair_err(3,2),100*cont1qupair_err(3,2),100*cont1qupair_err(3,1),100*cont1qupair_err(3,1),'Color','black','Marker','d','MarkerSize',5)                                    
e4 = errorbar(100*cont1qupair(4,1),100*cont1qupair(4,2),100*cont1qupair_err(4,2),100*cont1qupair_err(4,2),100*cont1qupair_err(4,1),100*cont1qupair_err(4,1),'Color','black','Marker','^','MarkerSize',5)                                
e5 = errorbar(100*cont1qupair(5,1),100*cont1qupair(5,2),100*cont1qupair_err(5,2),100*cont1qupair_err(5,2),100*cont1qupair_err(5,1),100*cont1qupair_err(5,1),'Color','black','Marker','v','MarkerSize',5)

plot(100*cont2qupair(:,1),100*cont2qupair(:,2),'Color',[0.9961 0.5373 0.0000])
errorbar(100*cont2qupair(1,1),100*cont2qupair(1,2),100*cont2qupair_err(1,2),100*cont2qupair_err(1,2),100*cont2qupair_err(1,1),100*cont2qupair_err(1,1),'Color',[0.9961 0.5373 0.0000])                                 
errorbar(100*cont2qupair(2,1),100*cont2qupair(2,2),100*cont2qupair_err(2,2),100*cont2qupair_err(2,2),100*cont2qupair_err(2,1),100*cont2qupair_err(2,1),'Color',[0.9961 0.5373 0.0000])                                 
errorbar(100*cont2qupair(3,1),100*cont2qupair(3,2),100*cont2qupair_err(3,2),100*cont2qupair_err(3,2),100*cont2qupair_err(3,1),100*cont2qupair_err(3,1),'Color',[0.9961 0.5373 0.0000])                               
errorbar(100*cont2qupair(4,1),100*cont2qupair(4,2),100*cont2qupair_err(4,2),100*cont2qupair_err(4,2),100*cont2qupair_err(4,1),100*cont2qupair_err(4,1),'Color',[0.9961 0.5373 0.0000])                             
errorbar(100*cont2qupair(5,1),100*cont2qupair(5,2),100*cont2qupair_err(5,2),100*cont2qupair_err(5,2),100*cont2qupair_err(5,1),100*cont2qupair_err(5,1),'Color',[0.9961 0.5373 0.0000])
box on
blah1 = line([-1 1],[0 0],'LineStyle','--','Color',[0 0 0]);
blah2 = line([0 0],[-1 1],'LineStyle','--','Color',[0 0 0]);
xlabel('Integrated q (\%)','FontSize',28,'interpreter','latex')
ylabel('Integrated u (\%)','FontSize',28,'interpreter','latex')

s1 = scatter(100*cont1qupair(1,1),100*cont1qupair(1,2),300,'x','MarkerFaceColor','Black','MarkerEdgeColor','Black')
s2 = scatter(100*cont1qupair(2,1),100*cont1qupair(2,2),300,'s','MarkerFaceColor','Black','MarkerEdgeColor','Black')
s3 = scatter(100*cont1qupair(3,1),100*cont1qupair(3,2),300,'d','MarkerFaceColor','Black','MarkerEdgeColor','Black')
s4 = scatter(100*cont1qupair(4,1),100*cont1qupair(4,2),300,'^','MarkerFaceColor','Black','MarkerEdgeColor','Black')
s5 = scatter(100*cont1qupair(5,1),100*cont1qupair(5,2),300,'v','MarkerFaceColor','Black','MarkerEdgeColor','Black')

s1_2 = scatter(100*cont2qupair(1,1),100*cont2qupair(1,2),300,'x','MarkerFaceColor',[0.9961 0.5373 0.0000],'MarkerEdgeColor',[0.9961 0.5373 0.0000])
s2_2 = scatter(100*cont2qupair(2,1),100*cont2qupair(2,2),300,'s','MarkerFaceColor',[0.9961 0.5373 0.0000],'MarkerEdgeColor',[0.9961 0.5373 0.0000])
s3_2 = scatter(100*cont2qupair(3,1),100*cont2qupair(3,2),300,'d','MarkerFaceColor',[0.9961 0.5373 0.0000],'MarkerEdgeColor',[0.9961 0.5373 0.0000])
s4_2 = scatter(100*cont2qupair(4,1),100*cont2qupair(4,2),300,'^','MarkerFaceColor',[0.9961 0.5373 0.0000],'MarkerEdgeColor',[0.9961 0.5373 0.0000])
s5_2 = scatter(100*cont2qupair(5,1),100*cont2qupair(5,2),300,'v','MarkerFaceColor',[0.9961 0.5373 0.0000],'MarkerEdgeColor',[0.9961 0.5373 0.0000])

text(0.125,0.4,'5100-5700 $\rm{\AA}$','interpreter','LaTex','FontSize',38)
text(0.125,0.3,'6000-6300 $\rm{\AA}$','interpreter','LaTex','FontSize',38,'Color',[0.9961 0.5373 0.0000])
ax1 = gca;
set(ax1,'FontSize',36)
set(ax1,'XMinorTick','on','YMinorTick','on')

[~, objh] = legend([s1, s2, s3, s4, s5],{'Epoch 1','Epoch 2','Epoch 3','Epoch 4','Epoch 5'},'FontSize',38)
objhl = findobj(objh, 'type', 'patch'); %// objects of legend of type line
set(objhl, 'Markersize', 20); %// set marker size as desired


saveas(plotting, [filename], 'epsc');
eval(['!epstopdf ' filename]);




