%% obtainConditionsOfInterest
%The goal of this function is to create a standard IDX output
% We also blaverage at this step (probably not the best place to do that)

%%
function IDX = obtainConditionsOfInterest(trialAlignedMUAPacket)

RESP    = trialAlignedMUAPacket.RESP;
win_ms  = trialAlignedMUAPacket.win_ms;
SDF     = trialAlignedMUAPacket.SDF;
sdftm   = trialAlignedMUAPacket.sdftm;
STIM    = trialAlignedMUAPacket.STIM;
clear trialAlignedMUAPacket 

if isequal(win_ms(3,:),[50 250])
    respDimension = 3;
elseif isequal(win_ms(4,:),[50 250])
    respDimension = 4;
else
    error('RESP dimension issue')
end

%% Crop SDF to .8 sec
tpFor800 = find(sdftm == .8);
SDFcrop = SDF(:,1:tpFor800,:);
sdftmCrop = sdftm(1:tpFor800);

%% baseline correct values
blAvg = nanmean(RESP(:,4,:),3); %the average bl firing rate for each contact
blSubSDF = SDFcrop - blAvg;
blSubRESP = RESP(:,1:3,:) - blAvg;


%% Condition selection.
% Note - you can pull out more monocular trials if needed. I did not in
% this case because I was woried about getting an oversampled monocular
% distribution. Not sure if this is an issue. I could always bootstrap or
% balance in another way. Basically, don't let a minimum number of
% monocular presentations hold you up. 
%% 1. PO Left Eye 16/13
%Monoc PO LeftEye 
trls.monocular_PO_LE = ...
    (STIM.bmcBRFSparamNum == 16 & STIM.first800 == true);

% IOT PO LeftEye post other eye adapt with congruent image
trls.IOT_PO_LE = STIM.bmcBRFSparamNum == 13 &...
    STIM.first800 == false &...
    STIM.fullTrial == true;

%% PO Right Eye 13/16
trls.monocular_PO_RE = ...
    (STIM.bmcBRFSparamNum == 13 & STIM.first800 == true) ;

% IOT PO LeftEye post other eye adapt with congruent image
trls.IOT_PO_RE = STIM.bmcBRFSparamNum == 16 &...
    STIM.first800 == false &...
    STIM.fullTrial == true;


%% NOP Left Eye 14/15
trls.monocular_NPO_LE = ...
    (STIM.bmcBRFSparamNum == 14 & STIM.first800 == true);

% IOT PO LeftEye post other eye adapt with congruent image
trls.IOT_NPO_LE = STIM.bmcBRFSparamNum == 15 &...
    STIM.first800 == false &...
    STIM.fullTrial == true;


%% NPO Right Eye 15/14
trls.monocular_NPO_RE = ...
    (STIM.bmcBRFSparamNum == 15 & STIM.first800 == true);

% IOT PO LeftEye post other eye adapt with congruent image
trls.IOT_NPO_RE = STIM.bmcBRFSparamNum == 14 &...
    STIM.first800 == false &...
    STIM.fullTrial == true;

%% Make groupd matrix

conditions = fieldnames(trls);
for f = 1:length(conditions)
    
    trlsLogical(:,f) = trls.(conditions{f});
    CondTrials{f} = find(trls.(conditions{f}));
    CondTrialNum(f,1) = sum(trls.(conditions{f})); 
    % SDF is a (1xf) cell. Each cell is (ms x trls) of data. i.e. (999 x 39) double
        condSelectSDF{f}   = blSubSDF(:,:,trls.(conditions{f}));  
    % RESP is a (1xf) cell. Each cell is (ms x trls) of data. i.e. (999 x 39) double
        condSelectRESP{f} = blSubRESP(:,:,trls.(conditions{f}));  
end






%% Get avg results
SDF_avg     = cell(size(conditions,1),1);
RESP_avg    = cell(size(conditions,1),1);

clear cond
for cond = 1:size(conditions,1)
    sdfholder = condSelectSDF{cond};
    SDF_avg{cond} = mean(condSelectSDF{cond},3);
    RESP_avg{cond}= mean(condSelectRESP{cond}(:,1,:),3);
end



%% SAVE  IDX
clear IDX

% Condition info
IDX.CondTrials = CondTrials;
IDX.conditions        = conditions;
IDX.CondTrialNum     = CondTrialNum;  
IDX.trlsLogical       = trlsLogical;
IDX.condSelectSDF   = condSelectSDF;
IDX.condSelectRESP  = condSelectRESP;
IDX.SDF_avg         = SDF_avg;
IDX.RESP_avg        = RESP_avg;
IDX.trls            = trls;
IDX.sdftmCrop       = sdftmCrop;



end