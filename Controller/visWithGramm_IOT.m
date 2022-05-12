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

fileOfInterest = {...
'211008_B_bmcBRFS001_FD.mat';
'211009_B_bmcBRFS002_FD.mat';
'211027_B_bmcBRFS002_FD.mat';
'211103_B_bmcBRFS001_FD.mat'};


%% Load in Data
[RIGDIR, CODEDIR, OUTDIR_FD, OUTDIR_PLOT] = setup_IOT('BrockHome');
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

% % % %% Oh man gramm is frustrating. Can I just plot this in matlab?
% % % quickAndDirtyMatlabPlot(IDX)


%% Depth assignemnt
global OUTDIR_FD
cd(OUTDIR_FD)
workbookFile = strcat(OUTDIR_FD,'laminarBoundaryCalculations.xlsx');
laminarBoundaryCalculations = importDepths(workbookFile);
clear -variables depths
for i = 1:size(allData,1)
    depths.upperBin{i,1} =  laminarBoundaryCalculations.UpperTop(i):1:laminarBoundaryCalculations.UpperBtm(i);
    depths.middleBin{i,1}  =  laminarBoundaryCalculations.MiddleTop(i):1:laminarBoundaryCalculations.MiddleBtm(i);
    depths.lowerBin{i,1}  = laminarBoundaryCalculations.LowerTop(i):1:laminarBoundaryCalculations.LowerBtm(i);
end

%% formatForGrammInput
clear forGramm
forGramm= formatForGrammInput(IDX,depths);
forJasp= formatForJaspInput(forGramm); %the response values need to be pre-split according to the levles you want to look across



%% plotStdIOTwithGramm
sdftm = IDX.sdftmCrop;
close all
plotStdIOTwithGramm(forGramm,sdftm)
 plotStdIOTwithGramm_LE(forGramm,sdftm)




%% Condition codes:
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



