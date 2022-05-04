%% obtainConditionsOfInterest
%The goal of this function is to create a standard IDX output

%%
function IDX = obtainConditionsOfInterest(trialAlignedMUAPacket)
global trialAlignedMUAPacket
holder = trialAlignedMUAPacket;
RESP    = holder.RESP;
win_ms  = holder.RESP;
SDF     = holder.SDF;
sdftm   = holder.sdftm;
STIM    = holder.STIM;
clear trialAlignedMUAPacket holder

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if isequal(win_ms(3,:),[50 250])
    respDimension = 3;
elseif isequal(win_ms(4,:),[50 250])
    respDimension = 4;
else
    error('RESP dimension issue')
end


clear trls  
%Monoc PO LeftEye 
trls.monocular = STIM.bmcBRFSparamNum == 16 &...
    STIM.first800 == true;

% Monoc PO LeftEye adapting post other eye adapt 
trls.IOT = STIM.bmcBRFSparamNum == 13 &...
    STIM.first800 == false &...
    STIM.fullTrial == true;

% % % % brfs 9
% % % trls.adapter_9 = STIM.bmcBRFSparamNum == 9 &...
% % %     STIM.first800 == true &...
% % %     STIM.fullTrial == true;
% % % trls.suppressor_9 = STIM.bmcBRFSparamNum == 9 &...
% % %     STIM.first800 == false &...
% % %     STIM.fullTrial == true;
% % % % brfs 10
% % % trls.adapter_10 = STIM.bmcBRFSparamNum == 10 &...
% % %     STIM.first800 == true &...
% % %     STIM.fullTrial == true;
% % % trls.suppressor_10 = STIM.bmcBRFSparamNum == 10 &...
% % %     STIM.first800 == false &...
% % %     STIM.fullTrial == true;
% % % % brfs 11
% % % trls.adapter_11 = STIM.bmcBRFSparamNum == 11 &...
% % %     STIM.first800 == true &...
% % %     STIM.fullTrial == true;
% % % trls.suppressor_11 = STIM.bmcBRFSparamNum == 11 &...
% % %     STIM.first800 == false &...
% % %     STIM.fullTrial == true;
% % % % brfs 12
% % % trls.adapter_12 = STIM.bmcBRFSparamNum == 12 &...
% % %     STIM.first800 == true &...
% % %     STIM.fullTrial == true;
% % % trls.suppressor_12 = STIM.bmcBRFSparamNum == 12 &...
% % %     STIM.first800 == false &...
% % %     STIM.fullTrial == true;


conditions = fieldnames(trls);
for f = 1:length(conditions)
    
    trlsLogical(:,f) = trls.(conditions{f});
    CondTrials{f} = find(trls.(conditions{f}));
    CondTrialNum(f,1) = sum(trls.(conditions{f})); 
    % SDF is a (1xf) cell. Each cell is (ms x trls) of data. i.e. (999 x 39) double
        SDF_uncrop{f}   = sdf(:,trls.(conditions{f}));  
    % RESP is a (1xf) cell. Each cell is (ms x trls) of data. i.e. (999 x 39) double
        RESP_alltrls{f} = resp(:,trls.(conditions{f}));  
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




%% crop SDF

        
%% baseline correct SDF


%% Get avg results
SDF_avg     = cell(size(conditions,1),1);
RESP_avg    = cell(size(conditions,1),1);

clear cond
for cond = 1:size(conditions,1)
    sdfholder = SDF_crop{cond};
    SDF_avg{cond} = mean(SDF_blCor{cond},2);
    RESP_avg{cond}= mean(RESP_alltrls{cond},2);
end



%% SAVE  IDX
clear IDX

% Condition info
IDX.CondTrials = CondTrials;
IDX.conditions        = conditions;
IDX.CondTrialNum     = CondTrialNum;        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


IDX = [];
end