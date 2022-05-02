%% createSTIM_IOT()
clear
setup_IOT('BrockWork')

%% Input manual variables
global RIGDIR
cd(RIGDIR)
cd('211008_B')
fullFileName = 'E:\bmcBRFSsessions\211008_B\211008_B_bmcBRFS001';



%% findTimePoints
% from STIM = brfsTP(filelist);
STIM = findTimePoints(fullFileName);
STIM.fullFileName = fullFileName;


%% alignToPhotoTrigger
trigger = 'custom';

[data, MLConfig, TrialRecord, filename] = mlread(fullFileName);
    PixelsPerDegree = MLConfig.PixelsPerDegree;
    ScreenResolution = MLConfig.Resolution;
    BehavioralCodes = TrialRecord.TaskInfo.BehavioralCodes;
     bhv = concatBHV(filename) %runs, but does not create resolution or ppd necessary

[STIM,fails] = photoReTriggerSTIM_bhv2Format(STIM,trigger);




%% alignNeuralDatToPhotoDiodeTrigger
% diNeuralDat
 
[RESP, win_ms, SDF, sdftm, PSTH, psthtm]= diNeuralDat(STIM,'mua',true);
