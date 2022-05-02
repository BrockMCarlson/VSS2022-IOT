%% preProcessNeuralData_IOT
% Desired output is an IDX matrix
clear
setup_IOT('BrockWork')

%% Setup File(s) to read
global RIGDIR
cd(RIGDIR)
cd('211008_B')
fullFileName = 'E:\bmcBRFSsessions\211008_B\211008_B_bmcBRFS001';



%% findTimePoints
% from STIM = brfsTP(filelist);
STIM = findTimePoints(fullFileName);
STIM.fullFileName = fullFileName;


%% alignToPhotoTrigger
%   NOTE YOU MUST HAVE THE NIMH MONKEY LOGIC APP OPEN FOR THESE
%   SUB-FUNCTIONS TO BE ON THE MATLAB PATH
trigger = 'custom';

[data, MLConfig, TrialRecord, filename] = mlread(fullFileName);
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

% Save your output
trialAlignedMUAPacket.RESP = RESP;
trialAlignedMUAPacket.win_ms = win_ms;
trialAlignedMUAPacket.SDF = SDF;
trialAlignedMUAPacket.sdftm = sdftm;
trialAlignedMUAPacket.PSTH = PSTH;
trialAlignedMUAPacket.psthtm = psthtm;

%% Test - plot one line from your data (this sould access Vies)
% This is the first time we have seen BRFS photo-diode triggered data
figure
holder = SDF(15,:,:);
holder2 = squeeze(holder);
holder3 = nanmean(holder2,2);
plot(holder3)
vline(150)
xlim([100 800])

%% Create IDX
% Make an IDX Structure that primarily houses 2 tables.
%   Table A - RESP trial-by-trial values for JASP WithinSubjectANOVA - raincloud plots!!
%   Table B - Continuous trial-bytrial values to average into SDFs using Gramm

% IDX = createIDX_IOT();
