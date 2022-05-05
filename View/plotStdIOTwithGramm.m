function plotStdIOTwithGramm(IDX)
%% concatenate inputs for Gramm
warning('using example unit')
exUnit = 15;

DataForVis.SDF(:,1:29) = IDX.condSelectSDF{1,1}(exUnit,:,:);
DataForVis.condLabel(:,1:29) = IDX.conditions{1,1};
DataForVis.SDF(:,30:51) = IDX.condSelectSDF{1,2}(exUnit,:,:);


%% Gramm plots for vis repeated trajectories
clear g

g(1,1)=gramm('x',TM,'y',DataForVis.SDF,'color',DataForVis.condLabel);
g.axe_property('XLim',[-.050 .5]);
g.axe_property('YLim',[0 200]);
g.geom_vline('xintercept',0)

g(1,1).stat_summary();
g(1,1).set_title('stat_summary()');
g(1,1).set_color_options('map','brewer2');
g(1,1).set_order_options('x',0,'color',0);
g(1,1).geom_polygon('x',{[.05 .1 .1 .05] ; [.15 .25 .25 .15]} ,'y',{[40 40 190 190];  [40 40 190 190]},'color',[.5 .5 .5]);


g.set_names('x','Time (sec)','y','Impulses/sec','color','Visual Stimulus');
g.set_title('Dichoptic Suppression');
% figure('Position',[100 100 800 550]);
figure('Position',[166.6000 157.8000 1.0136e+03 549.6000]);

g.draw();

set([g.results.stat_summary.line_handle],'LineWidth',3);




    

end