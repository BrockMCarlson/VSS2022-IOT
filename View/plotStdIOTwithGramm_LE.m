function plotStdIOTwithGramm_NDE(forGramm,sdftm)

%% Gramm plots for vis repeated trajectories
clear g
g(1,1)=gramm('x',sdftm,'y',forGramm.SDF_trials,'color',forGramm.trlLabel,...
    'subset',...
    ((strcmp(forGramm.trlLabel, 'monocular_PO_NDE') | strcmp(forGramm.trlLabel, 'IOT_PO_NDE')) & ...
    strcmp(forGramm.depthLabel, 'U')));
g(2,1)=gramm('x',sdftm,'y',forGramm.SDF_trials,'color',forGramm.trlLabel,...
    'subset',...
    ((strcmp(forGramm.trlLabel, 'monocular_PO_NDE') | strcmp(forGramm.trlLabel, 'IOT_PO_NDE')) & ...
    strcmp(forGramm.depthLabel, 'M')));
g(3,1)=gramm('x',sdftm,'y',forGramm.SDF_trials,'color',forGramm.trlLabel,...
    'subset',...
    ((strcmp(forGramm.trlLabel, 'monocular_PO_NDE') | strcmp(forGramm.trlLabel, 'IOT_PO_NDE')) & ...
    strcmp(forGramm.depthLabel, 'L')));


g(1,1).stat_summary();
g(2,1).stat_summary();
g(3,1).stat_summary();
g.axe_property('YLim',[-1 7]);
g.axe_property('XLim',[-.05 .3]);



g.draw();


%% Plot global average
hold off
clear h
h(1,1)=gramm('x',sdftm,'y',forGramm.SDF_trials,'color',forGramm.trlLabel,...
    'subset',...
        strcmp(forGramm.trlLabel, 'monocular_PO_NDE') |...
        strcmp(forGramm.trlLabel, 'IOT_PO_NDE'));



h(1,1).stat_summary();
h.axe_property('YLim',[-1 6]);
h.axe_property('XLim',[-.05 .3]);


figure('Position',[80 516 560 420]);
h.draw();


%% Plot categorical
% X - trans vs sustained categorical Y - response values. Color is monoc vs IOT
% Use Geom_jitter

clear i i2

i(1,1)=gramm('x',forGramm.RESPbinLabel,'y',forGramm.RESPbinVal,...
    'color',forGramm.trlLabel,...
    'subset',...
        strcmp(forGramm.trlLabel, 'monocular_PO_NDE') |...
        strcmp(forGramm.trlLabel, 'IOT_PO_NDE'));


%Boxplots
i(1,1).stat_boxplot('width',0.15);
i(1,1).set_title('stat_boxplot()');

%Violin plots
i(1,1).stat_violin('fill','transparent');
i(1,1).set_title('stat_violin()');

%These functions can be called on arrays of gramm objects
i.set_names('x','Time window of response','y','aMUA spiking response','color','Visual stimulus');
i.set_title('Transient vs sustained firing');



figure('Position',[100 100 800 550]);
i.draw();





%% Plot categorical of layers - and then flip to a row based categorical
% X - Laminar compartments. Y - response values. Color is monoc vs IOT, AND
% transient
% Use Geom_jitter

clear j 

j(1,1)= gramm('x',forGramm.depthLabel,'y',forGramm.RESPbinVal,...
    'color',forGramm.trlLabel,...
    'subset',(...
        ( strcmp(forGramm.trlLabel, 'monocular_PO_NDE') | strcmp(forGramm.trlLabel, 'IOT_PO_NDE') ) &...
        ( strcmp(forGramm.RESPbinLabel,'Transient') & ~strcmp(forGramm.depthLabel,'O'))...
        )...
        );


%Boxplots
j(1,1).stat_boxplot('width',0.15);
j(1,1).set_title('stat_boxplot()');

%Violin plots
j(1,1).stat_violin('fill','transparent');
j(1,1).set_title('stat_violin()');

%These functions can be called on arrays of gramm objects
j.set_names('x','Laminar compartment','y','aMUA spiking response','color','Visual stimulus');
j.set_title('Transient period of neural response - 50-100ms');


figure('Position',[872 54 467 550]);
j.coord_flip()
j.draw();

clear k 

k(1,1)= gramm('x',forGramm.depthLabel,'y',forGramm.RESPbinVal,...
    'color',forGramm.trlLabel,...
    'subset',(...
        ( strcmp(forGramm.trlLabel, 'monocular_PO_NDE') | strcmp(forGramm.trlLabel, 'IOT_PO_NDE') ) &...
        ( strcmp(forGramm.RESPbinLabel,'Sustained') & ~strcmp(forGramm.depthLabel,'O'))...
        )...
        );


%Boxplots
k(1,1).stat_boxplot('width',0.15);
k(1,1).set_title('stat_boxplot()');

%Violin plots
k(1,1).stat_violin('fill','transparent');
k(1,1).set_title('stat_violin()');

%These functions can be called on arrays of gramm obkects
k.set_names('x','Laminar compartment','y','aMUA spiking response','color','Visual Stimulus');
k.set_title('Sustained period of neural response - 150-250ms');


figure('Position',[1396 57 467 548]);
k.coord_flip()
k.draw();


%% Save all the figs
global OUTDIR_PLOT  
cd(OUTDIR_PLOT)
figNameList = {'Lam_Sus','Lam_Trans','TransVsSus','allContactLine','Lam_Line'};

FolderName = strcat(OUTDIR_PLOT,'figsFrom-plotStdIOTwithGramm_LE\');   % Your destination folder
cd(FolderName)
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = figNameList{iFig};
  savefig(FigHandle, strcat(FolderName, FigName, '.fig'));
  saveas(FigHandle, strcat(FolderName, FigName, '.svg'));

end



    

end

