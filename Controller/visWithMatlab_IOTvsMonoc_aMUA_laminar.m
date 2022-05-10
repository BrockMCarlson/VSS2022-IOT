%% Manual Inputs 
clear
% close all

% Only the first 8 files are pre-processed right now. Several days show
% extreamly poor MUA. I will skip these sessions for now, but I think they
% are all recoverable. Just need some de-bugging to happen in the
% pre-processing step (after VSS).

for fileNumber = 1:8
    close all
    %% Load in Data
     [RIGDIR, CODEDIR, OUTDIR_FD, OUTDIR_PLOT] = setup_IOT('BrockHome');
     global OUTDIR_FD
     cd(OUTDIR_FD)
    % Automate file name generation
        sessionListName = {'211008_B'; '211009_B'; '211012_B'; '211025_B'; '211027_B'; '211102_B'; '211103_B'; '211105_B'; '211208_B'; '211210_B'; '211213_B'; '211217_B'};
    % %     lastEvpNumber.array = {4,5,3,5,2,3,4,6,4,4,5,3};
    % %     lastEvpNumber.string = cellfun(@num2str,lastEvpNumber.array,'un',0); %turn any cell of arrays and strings into all strings
        bmcBRFSNumber.array = {1,2,1,1,2,1,1,1,1,1,1,1};
        bmcBRFSNumber.string = cellfun(@num2str,bmcBRFSNumber.array,'un',0); %turn any cell of arrays and strings into all strings
        sessionOfInterest = strcat(OUTDIR_FD,sessionListName{fileNumber},...
            '_bmcBRFS00',bmcBRFSNumber.string{fileNumber},'_FD.mat');
    load(sessionOfInterest)
    
    
    
    %% obtainConditionsOfInterest()
    % The goal of this file is to generate an IDX output
    IDX = obtainConditionsOfInterest(trialAlignedMUAPacket);
    
    %% Oh man gramm is frustrating. Can I just plot this in matlab?
    quickAndDirtyMatlabPlot(IDX,sessionListName{fileNumber})
end
global OUTDIR_PLOT
cd(strcat(OUTDIR_PLOT,'figsFrom-quickAndDirtyMatlabPlot'))
% % %% Save all the figs
% % figNameList = {'Lam_Sus','Lam_Trans','TransVsSus','allContactLine','Lam_Line'};
% % FolderName = strcat(OUTDIR_PLOT,'figsFrom-visWithGramm_IOT\');   % Your destination folder
% % saveAllTheFigs(figNameList,FolderName)
