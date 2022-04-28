%% createSTIM_IOT()
clear
setup_IOT('BrockWork')

%% Input manual variables
global RIGDIR
cd(RIGDIR)
cd('211008_B')
fullFileName = 'E:\bmcBRFSsessions\211008_B\211008_B_bmcBRFS001';



%% Pull out all pertinent time-points from all sessions of interest
% runTuneList, diTP, diCheck, diPT, diV1Lim

STIM = brfsTP(filelist);
trigger = 'custom';
[STIM,fails] = diPT_2021(STIM,trigger);

[RESP, win_ms, SDF, sdftm, PSTH, psthtm]= diNeuralDat(STIM,datatype,true);



%% Pull out the data - time locked to photo-triggered time-points
% diNeuralDat