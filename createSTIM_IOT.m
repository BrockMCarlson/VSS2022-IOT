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



%% alignToPhotoTrigger
trigger = 'custom';
[STIM,fails] = diPT_2021(STIM,trigger);




%% alignNeuralDatToPhotoDiodeTrigger
% diNeuralDat

[RESP, win_ms, SDF, sdftm, PSTH, psthtm]= diNeuralDat(STIM,datatype,true);
