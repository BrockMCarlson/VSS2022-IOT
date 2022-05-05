function plotStdIOTwithGramm(inputUnitTableToGramm,sdftm)


%% Gramm plots for vis repeated trajectories
clear g

g(1,1)=gramm('x',sdftm,'y',inputUnitTableToGramm.SDF_trials,'color',inputUnitTableToGramm.trlLabel,...
    'subset',strcmp(inputUnitTableToGramm.trlLabel, 'Monocular_PO_RE') |...
    strcmp(inputUnitTableToGramm.trlLabel, 'IOT_PO_RE'));
% 
% g(1,2)=copy(g(1));
% g(2,1)=copy(g(1));
% g(2,2)=copy(g(1));
% 
% g(1,1).geom_point();
% g(1,1).set_title('geom_point()');
% 
% g(1,2).geom_line();
% g(1,2).set_title('geom_line()');
% 
% g(2,1).stat_smooth();
% g(2,1).set_point_options('base_size',3);
% g(2,1).set_title('stat_smooth()');


g(1,1).stat_summary();
% g(2,2).set_title('stat_summary()');
% g.axe_property('YLim',[-10 50]);


g.set_title('Visualization of repeated trajectories ');

figure('Position',[100 100 800 550]);
g.draw();

    

end



% % 
% % 
% % %%%%%%%%%%%%%%%%%%%
% % clear g
% % 
% % g(1,1)=gramm('x',sdftm,'y',inputUnitTableToGramm.SDF_trials,'color',inputUnitTableToGramm.trlLabel);
% % % % g.axe_property('XLim',[-.050 .5]);
% % % % g.axe_property('YLim',[0 200]);
% % % % g.geom_vline('xintercept',0)
% % 
% % g(1,1).stat_summary();
% % g(1,1).set_title('stat_summary()');
% % g(1,1).set_color_options('map','brewer2');
% % g(1,1).set_order_options('x',0,'color',0);
% % g(1,1).geom_polygon('x',{[.05 .1 .1 .05] ; [.15 .25 .25 .15]} ,'y',{[40 40 190 190];  [40 40 190 190]},'color',[.5 .5 .5]);
% % 
% % 
% % g.set_names('x','Time (sec)','y','Impulses/sec','color','Visual Stimulus');
% % g.set_title('Dichoptic Suppression');
% % % figure('Position',[100 100 800 550]);
% % figure('Position',[166.6000 157.8000 1.0136e+03 549.6000]);
% % 
% % g.draw();
% % 
% % set([g.results.stat_summary.line_handle],'LineWidth',3);
% % 
