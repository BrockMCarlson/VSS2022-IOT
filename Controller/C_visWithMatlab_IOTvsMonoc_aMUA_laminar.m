%Matlab
%% Manual Inputs 
clear
close all

fileOfInterest = {...
'211008_B_bmcBRFS001_FD.mat';
'211009_B_bmcBRFS002_FD.mat';
'211027_B_bmcBRFS002_FD.mat';
'211103_B_bmcBRFS001_FD.mat'};


%% Load in Data
setup_IOT('BrockHome')
global OUTDIR_FD
cd(OUTDIR_FD)
clear allData
for rn = 1:4
    allData{rn,1} = fileOfInterest{rn};
    clear trialAlignedMUAPacket
     load(fileOfInterest{rn});
     allData{rn,2} = trialAlignedMUAPacket;
end



%% obtainConditionsOfInterest()
% The goal of this file is to generate an IDX output
IDX = obtainConditionsOfInterest(allData);

    
% Quick matlab plot for preference assignment.
close all
for i = 1:4
    figure
    SessionAvg_PO_LE = smoothdata(nanmean(IDX.SDF_avg{i,1},1),2,'gaussian',15);
    SessionAvg_PO_RE = smoothdata(nanmean(IDX.SDF_avg{i,3},1),2,'gaussian',15);
    SessionAvg_NPO_LE = smoothdata(nanmean(IDX.SDF_avg{i,5},1),2,'gaussian',15);
    SessionAvg_NPO_RE = smoothdata(nanmean(IDX.SDF_avg{i,7},1),2,'gaussian',15);
    plot(IDX.sdftmCrop,SessionAvg_PO_LE); hold on
    plot(IDX.sdftmCrop,SessionAvg_PO_RE); hold on
    plot(IDX.sdftmCrop,SessionAvg_NPO_LE); hold on
    plot(IDX.sdftmCrop,SessionAvg_NPO_RE); hold on
    legend('SessionAvg_PO_LE','SessionAvg_PO_RE','SessionAvg_NPO_LE','SessionAvg_NPO_RE','Interpreter','none')
    
end



% Broken...
% % quickAndDirtyMatlabPlot(IDX_ss,sessionListName{fileNumber})


%% View outputs
global OUTDIR_PLOT
cd(strcat(OUTDIR_PLOT,'figsFrom-quickAndDirtyMatlabPlot'))

