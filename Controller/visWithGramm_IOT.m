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
IDX = obtainConditionsOfInterest(trialAlignedMUAPacket);


%% Oh man gramm is frustrating. Can I just plot this in matlab?
quickAndDirtyMatlabPlot(IDX)


%% formatForGrammInput
clear forGramm
for i = 1:32
    forGramm= formatForGrammInput(IDX,i);
    eachUnitForGramm{i} = forGramm; 
end



%% plotStdIOTwithGramm
sdftm = IDX.sdftmCrop;
clear i
for i = 1:32
    inputUnitTableToGramm = eachUnitForGramm{i};
    plotStdIOTwithGramm(inputUnitTableToGramm,sdftm)
end




% Condition codes:
% 1     'Simult. Dioptic. PO',...
% 2     'Simult. Dioptic. NPO',...
% 3     'Simult. Dichoptic. PO LeftEye - NPO RightEye',...
% 4     'Simult. Dichoptic. NPO LeftEye - PO RightEye',...
% 5     'BRFS-like Congruent Adapted Flash. C PO RightEye adapting - PO LeftEye flashed',... 
% 6     'BRFS-like Congruent Adapted Flash. C NPO LeftEye adapting - NPO RightEye flashed',... 
% 7     'BRFS-like Congruent Adapted Flash. C NPO RightEye  adapting - NPO LeftEye flashed',... 
% 8     'BRFS-like Congruent Adapted Flash. C PO LeftEye adapting - PO RightEye flashed',... 
% 9     'BRFS IC Adapted Flash. NPO RightEye adapting - PO LeftEye flashed',... 
% 10    'BRFS IC Adapted Flash. PO LeftEye adapting - NPO RightEye flashed',... 
% 11    'BRFS IC Adapted Flash. PO RightEye adapting - NPO LeftEye flashed',... 
% 12    'BRFS IC Adapted Flash. NPO LeftEye adapting - PO RightEye flashed',... 

% 13    'Monoc Alt Congruent Adapted. C PO RightEye adapting - PO LeftEye alternat monoc presentation',... 
% 14    'Monoc Alt Congruent Adapted. C NPO LeftEye adapting - NPO RightEye alternat monoc presentation',... 
% 15    'Monoc Alt Congruent Adapted. C NPO RightEye  adapting - NPO LeftEye alternat monoc presentation',... 
% 16    'Monoc Alt Congruent Adapted. C PO LeftEye adapting - PO RightEye alternat monoc presentation',... 

% 17    'Monoc Alt IC Adapted. NPO RightEye adapting - PO LeftEye alternat monoc presentation',... 
% 18    'Monoc Alt IC Adapted. PO LeftEye adapting - NPO RightEye alternat monoc presentation',... 
% 19    'Monoc Alt IC Adapted. PO RightEye adapting - NPO LeftEye alternat monoc presentation',... 
% 20    'Monoc Alt IC Adapted. NPO LeftEye adapting - PO RightEye alternat monoc presentation',... 



