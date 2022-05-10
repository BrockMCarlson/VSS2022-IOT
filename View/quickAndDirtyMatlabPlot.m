% plot IDX.SDF_avg
function quickAndDirtyMatlabPlot(IDX,sessionName)
close all
conditions = IDX.conditions;
SDF_avg = IDX.SDF_avg;
exUnit = 15;

%smoothData
clear SDF_smoothed
for sd = 1:8
    [SDF_smoothed{sd,1},window] = smoothdata(IDX.SDF_avg{sd},2,'gaussian',15);
end

%% Create a more usable table
% If the inputs are workspace variables, then table assigns their names as 
% the variable names in the output table.

%Variable to put into this table
monocular_PO_LE     =  SDF_smoothed{1,1}; 
IOT_PO_LE           =  SDF_smoothed{2,1};  
monocular_PO_RE     =  SDF_smoothed{3,1}; 
IOT_PO_RE           =  SDF_smoothed{4,1}; 
monocular_NPO_LE    =  SDF_smoothed{5,1}; 
IOT_NPO_LE          =  SDF_smoothed{6,1}; 
monocular_NPO_RE    =  SDF_smoothed{7,1}; 
IOT_NPO_RE          =  SDF_smoothed{8,1}; 

sorted = table(monocular_PO_LE,...
    IOT_PO_LE,...  
monocular_PO_RE,...
IOT_PO_RE,...
monocular_NPO_LE,...
IOT_NPO_LE,...
monocular_NPO_RE,...
IOT_NPO_RE);


%% PO_LE
% Plot all contacts in one tiledLayout
clear i
g = figure;
tiledlayout('flow')
for i = 1:32 % contacts
   nexttile
%     subplot(22,2,i) % PO RE
    plot(IDX.sdftmCrop,sorted{i,1}); hold on
    plot(IDX.sdftmCrop,sorted{i,2})
    xlim([-.15 .35])
    ylim([-5 15])
    vline(0)
    title(strcat('Chan Number',string(i)))
end
g.Position = [142 65 1733 889];
figName = strcat(sessionName,'_aMUA of monoc vs IOT of PO_LE');
sgtitle(figName,'Interpreter','none')



% Save output
global OUTDIR_PLOT
FolderName = strcat(OUTDIR_PLOT,'figsFrom-quickAndDirtyMatlabPlot\');
cd(FolderName)
  savefig(g, strcat(FolderName, sessionName, 'aMUA_PO_LE.fig'));
  saveas(g, strcat(FolderName, sessionName, 'aMUA_PO_LE.svg'));
  saveas(g, strcat(FolderName, sessionName, 'aMUA_PO_LE.png'));

%% PO_RE
% Plot all contacts in one tiledLayout
clear i
f = figure;
tiledlayout('flow')
for i = 1:32 % contacts
   nexttile
%     subplot(22,2,i) % PO RE
    plot(IDX.sdftmCrop,sorted{i,3}); hold on
    plot(IDX.sdftmCrop,sorted{i,4})
    xlim([-.15 .35])
    ylim([-5 15])
    vline(0)
    title(strcat('Chan Number',string(i)))
end
f.Position = [142 65 1733 889];
figName = strcat(sessionName,'_aMUA of monoc vs IOT of PO_RE');
sgtitle(figName,'Interpreter','none')



% Save output
global OUTDIR_PLOT
FolderName = strcat(OUTDIR_PLOT,'figsFrom-quickAndDirtyMatlabPlot\');
cd(FolderName)
  savefig(f, strcat(FolderName, sessionName, 'aMUA_PO_RE.fig'));
  saveas(f, strcat(FolderName, sessionName, 'aMUA_PO_RE.svg'));
  saveas(f, strcat(FolderName, sessionName, 'aMUA_PO_RE.png'));




  %% NPO_LE
% Plot all contacts in one tiledLayout
clear i
g = figure;
tiledlayout('flow')
for i = 1:32 % contacts
   nexttile
%     subplot(22,2,i) % PO RE
    plot(IDX.sdftmCrop,sorted{i,5}); hold on
    plot(IDX.sdftmCrop,sorted{i,6})
    xlim([-.15 .35])
    ylim([-5 15])
    vline(0)
    title(strcat('Chan Number',string(i)))
end
g.Position = [142 65 1733 889];
figName = strcat(sessionName,'_aMUA of monoc vs IOT of NPO_LE');
sgtitle(figName,'Interpreter','none')



% Save output
global OUTDIR_PLOT
FolderName = strcat(OUTDIR_PLOT,'figsFrom-quickAndDirtyMatlabPlot\');
cd(FolderName)
  savefig(g, strcat(FolderName, sessionName, 'aMUA_NPO_LE.fig'));
  saveas(g, strcat(FolderName, sessionName, 'aMUA_NPO_LE.svg'));
  saveas(g, strcat(FolderName, sessionName, 'aMUA_NPO_LE.png'));



  %% NPO_RE
% Plot all contacts in one tiledLayout
clear i
g = figure;
tiledlayout('flow')
for i = 1:32 % contacts
   nexttile
%     subplot(22,2,i) % PO RE
    plot(IDX.sdftmCrop,sorted{i,7}); hold on
    plot(IDX.sdftmCrop,sorted{i,8})
    xlim([-.15 .35])
    ylim([-5 15])
    vline(0)
    title(strcat('Chan Number',string(i)))
end
g.Position = [142 65 1733 889];
figName = strcat(sessionName,'_aMUA of monoc vs IOT of NPO_RE');
sgtitle(figName,'Interpreter','none')



% Save output
global OUTDIR_PLOT
FolderName = strcat(OUTDIR_PLOT,'figsFrom-quickAndDirtyMatlabPlot\');
cd(FolderName)
  savefig(g, strcat(FolderName, sessionName, 'aMUA_NPO_RE.fig'));
  saveas(g, strcat(FolderName, sessionName, 'aMUA_NPO_RE.svg'));
  saveas(g, strcat(FolderName, sessionName, 'aMUA_NPO_RE.png'));


  %% 2x2 monocular average for whole electrode
  % First we have to average across all contacts
  clear condLp
    for condLp = 1:8
        elAvg.(IDX.conditions{condLp}) = nanmean(IDX.SDF_avg{condLp,1},1)';
    end


  % Then we can plot the 2x2
    twoByTwo = figure;
    sgtitle(strcat('2x2plotFor--',sessionName))
    clear i
    for i = 1:4
        subplot(2,2,i) 
        plot(elAvg.()); hold on
        plot(IDX.sdftmCrop,sorted{i,4})
        xlim([-.15 .35])
        ylim([-5 20])
        legend('monocular','adapted');
        title(condOrder{i})

    end

    subplot(2,2,1) % PO RE
    plot(IDX.sdftmCrop,sorted{i,3}); hold on
    plot(IDX.sdftmCrop,sorted{i,4})
    xlim([-.15 .35])
    ylim([-5 15])
    legend('monocular','adapted')
    title('PO RE')

    subplot(2,2,2) % PO LE
    plot(IDX.sdftmCrop,sorted{i,1}); hold on
    plot(IDX.sdftmCrop,sorted{i,2})
    xlim([-.15 .35])
    ylim([-5 15])
    legend('monocular','adapted')
    title('PO LE')

    subplot(2,2,3) % NPO RE    
    plot(IDX.sdftmCrop,sorted{i,7}); hold on
    plot(IDX.sdftmCrop,sorted{i,8})
    xlim([-.15 .35])
    ylim([-5 15])
    legend('monocular','adapted')
    title('NPO RLE')

    subplot(2,2,4) % NPO LE
    plot(IDX.sdftmCrop,sorted{i,5}); hold on
    plot(IDX.sdftmCrop,sorted{i,6})
    xlim([-.15 .35])
    ylim([-5 15])
    legend('monocular','adapted')
    title('NPO LE')

  


end
