%% preProcessNeuralData_IOT
% Desired output is an IDX matrix
clear
setup_IOT('BrockHome')

%% Setup File(s) to read
global RIGDIR
cd(RIGDIR)
cd('211208_B')
fullFileName = 'E:\bmcBRFSsessions\211208_B\211208_B_bmcBRFS001';



%% findTimePoints
% from STIM = brfsTP(filelist);
STIM = findTimePoints(fullFileName);
STIM.fullFileName = fullFileName;
STIM.localFileName = fullFileName(end-18:end);

%% alignToPhotoTrigger
%   NOTE YOU MUST HAVE THE NIMH MONKEY LOGIC APP OPEN FOR THESE
%   SUB-FUNCTIONS TO BE ON THE MATLAB PATH
trigger = 'custom';

bhvFile = strcat(fullFileName,'.bhv2');
[data, MLConfig, TrialRecord, filename] = mlread(bhvFile);
% % % %     PixelsPerDegree = MLConfig.PixelsPerDegree;
% % % %     ScreenResolution = MLConfig.Resolution;
% % % %     BehavioralCodes = TrialRecord.TaskInfo.BehavioralCodes;
% % % %      bhv = concatBHV(filename) %runs, but does not create resolution or ppd necessary

TP = STIM.tp_sp;
[newTP,trigger] = photoReTriggerSTIM_2021(TP,fullFileName,0,trigger);
%%% --> BMC and blake - photoReTriggerSTIM is an example of a code that
%%% would benefit from editing errors (or exclusions) out of existance

STIM.tp_pt = newTP;


%% trialAlignNeuralData
% diNeuralDat has turned into trialAlignData_IOT
    %You need to obtain STIM.ellabels. This is generated in diV1Lim code
    %(something that is an antiquated function form ephys analysis). I need
    %to figure out how to openNEV for el_labels
        win_ms    = [50 100; 150 250; 50 250; -50 0]; % ms;

[RESP, win_ms, SDF, sdftm, PSTH, psthtm] = trialAlignData_IOT(STIM,'mua',true,win_ms);

% Save your output -- approx 225 MB
trialAlignedMUAPacket.RESP = RESP;
trialAlignedMUAPacket.win_ms = win_ms;
trialAlignedMUAPacket.SDF = SDF;
trialAlignedMUAPacket.sdftm = sdftm;
trialAlignedMUAPacket.PSTH = PSTH;
trialAlignedMUAPacket.psthtm = psthtm;
trialAlignedMUAPacket.STIM = STIM;

global OUTDIR_FD
cd(OUTDIR_FD)
saveFileName = strcat(OUTDIR_FD,STIM.localFileName ,'_FD.mat');
save(saveFileName,"trialAlignedMUAPacket");

%% Test - plot one line from your data (this sould access Vis)
% This is the first time we have seen BRFS photo-diode triggered data
figure
for sp = 1:10
    subplot(10,1,sp)
    holder = SDF(sp+20,:,:);
    holder2 = squeeze(holder);
    holder3 = nanmean(holder2,2);
    plot(holder3)
    vline(150)
    xlim([100 800])
end


