%% obtainConditionsOfInterest
%The goal of this function is to create a standard IDX output
% We also blaverage at this step (probably not the best place to do that)

%%
function IDX = obtainConditionsOfInterest(allData)



SDF_avg     = cell(4,8);
RESP_avg    = cell(4,8);
for i = 1:size(allData,1)
    trialAlignedMUAPacket = allData{i,2};
        RESP    = trialAlignedMUAPacket.RESP;
        win_ms  = trialAlignedMUAPacket.win_ms;
        SDF     = trialAlignedMUAPacket.SDF;
        sdftm   = trialAlignedMUAPacket.sdftm;
        STIM    = trialAlignedMUAPacket.STIM;
        clear trialAlignedMUAPacket 
    
    
    %% Crop SDF to .8 sec
        tpFor800 = find(sdftm == .8);
        SDFcrop = SDF(:,1:tpFor800,:);
        sdftmCrop = sdftm(1:tpFor800);
    
    %% baseline correct values
    monocTrls = STIM.first800;
    blAvg = nanmean(RESP(:,4,monocTrls),3); %the average bl firing rate for each contact
    blStd = nanstd(RESP(:,4,monocTrls),1,3); %the average bl firing rate for each contact
    blSubSDF = SDFcrop - blAvg;
    blSubRESP = RESP(:,1:3,:) - blAvg;

    %% Z-scored change from baseline
    zsSDF = (SDFcrop - blAvg) ./ (blStd);
    zsRESP = (RESP - blAvg) ./ (blStd);
%     smoothdata(zsSDF,
    
    %% Condition selection.
    % Note - you can pull out more monocular trials if needed. I did not in
    % this case because I was woried about getting an oversampled monocular
    % distribution. Not sure if this is an issue. I could always bootstrap or
    % balance in another way. Basically, don't let a minimum number of
    % monocular presentations hold you up. 

    eyeDominance = {'RE','LE','LE','LE'};
    if i == 1
         %% 1. PO Left Eye 16/13
        %Monoc PO LeftEye 
        trls.monocular_PO_NDE = ...
            (STIM.bmcBRFSparamNum == 16 & STIM.first800 == true);
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_PO_NDE = STIM.bmcBRFSparamNum == 13 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;
        
        %% PO Right Eye 13/16
        trls.monocular_PO_DE = ...
            (STIM.bmcBRFSparamNum == 13 & STIM.first800 == true) ;
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_PO_DE = STIM.bmcBRFSparamNum == 16 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;
        
        
        %% NOP Left Eye 14/15
        trls.monocular_NPO_NDE = ...
            (STIM.bmcBRFSparamNum == 14 & STIM.first800 == true);
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_NPO_NDE = STIM.bmcBRFSparamNum == 15 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;
        
        
        %% NPO Right Eye 15/14
        trls.monocular_NPO_DE = ...
            (STIM.bmcBRFSparamNum == 15 & STIM.first800 == true);
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_NPO_DE = STIM.bmcBRFSparamNum == 14 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;


    else 
        %% 1. PO Left Eye 16/13
        %Monoc PO LeftEye 
        trls.monocular_PO_DE = ...
            (STIM.bmcBRFSparamNum == 16 & STIM.first800 == true);
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_PO_DE = STIM.bmcBRFSparamNum == 13 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;
        
        %% PO Right Eye 13/16
        trls.monocular_PO_NDE = ...
            (STIM.bmcBRFSparamNum == 13 & STIM.first800 == true) ;
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_PO_NDE = STIM.bmcBRFSparamNum == 16 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;
        
        
        %% NOP Left Eye 14/15
        trls.monocular_NPO_DE = ...
            (STIM.bmcBRFSparamNum == 14 & STIM.first800 == true);
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_NPO_DE = STIM.bmcBRFSparamNum == 15 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;
        
        
        %% NPO Right Eye 15/14
        trls.monocular_NPO_NDE = ...
            (STIM.bmcBRFSparamNum == 15 & STIM.first800 == true);
        
        % IOT PO LeftEye post other eye adapt with congruent image
        trls.IOT_NPO_NDE = STIM.bmcBRFSparamNum == 14 &...
            STIM.first800 == false &...
            STIM.fullTrial == true;
    end
    
    %% Make groupd matrix
    
    saveConditions{i} = fieldnames(trls);
    conditions = fieldnames(trls);
        for f = 1:length(conditions)
            
            CondTrials{i,f} = find(trls.(conditions{f}));
            CondTrialNum{i,f}  = sum(trls.(conditions{f})); 
            % SDF is a (1xf) cell. Each cell is (ms x trls) of data. i.e. (999 x 39) double
                condSelectSDF{i,f}    = zsSDF(:,:,trls.(conditions{f}));  
            % RESP is a (1xf) cell. Each cell is (ms x trls) of data. i.e. (999 x 39) double
                condSelectRESP{i,f}  = zsRESP(:,:,trls.(conditions{f}));  
        end

    

 
 
    %% Get avg results

    clear cond
    for cond = 1:size(conditions,1)
        SDF_avg{i,cond}  = mean(condSelectSDF{i,cond},3);
        RESP_avg{i,cond}= mean(condSelectRESP{i,cond}(:,1,:),3);
    end




end

    %% SAVE  IDX
    clear IDX
    
    % Condition info
    IDX.CondTrials = CondTrials;
    IDX.saveConditions        = saveConditions;
    IDX.conditions        = conditions;
    IDX.CondTrialNum     = CondTrialNum;  
    IDX.condSelectSDF   = condSelectSDF;
    IDX.condSelectRESP  = condSelectRESP;
    IDX.SDF_avg         = SDF_avg;
    IDX.RESP_avg        = RESP_avg;
    IDX.trls            = trls;
    IDX.sdftmCrop       = sdftmCrop;
    IDX.win_ms          = win_ms;

    
end