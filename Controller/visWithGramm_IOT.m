%% visWithGramm_IOT
% This Github release is at the controller level and is accessing 
% sub-routines in the Viewer level. This controller interface is intended 
% to create Gramm plots of the standard IOT comparison. Standard IOT 
% (aka stdIOTcomp) is simply the monocular presentation of one eye compared 
% to the same presentation after adaptation in the other eye. 

% This controller interface is intended to take in the the SDF and STIM 
% variable outputs created in the pre-processing step. It will then format 
% them for proper gramm inputs. Finally, the controller will interact with
% the View directory to format and plot the figures using Gramm.

%% Manual Inputs 
clear
close all

sessionOfInterest = '211008_B_bmcBRFS001';

%% Load in Data
setup_IOT('BrockWork')
global OUTDIR_FD
cd(OUTDIR_FD)
formattedFileName = strcat(sessionOfInterest,'_FD.mat');
load(formattedFileName)



%% obtainConditionsOfInterest()
% The goal of this file is to generate an IDX output
global trialalignedMUAPacket
IDX = obtainConditionsOfInterest(trialAlignedMUAPacket);





%% formatForGrammInput





%% plotStdIOTwithGramm




