function forGramm = formatForGrammInput(IDX,depths)
%% Format of forGramm output variable
% The desired output here is to make a (n x 4) cell array where n is the
% number of trials. In the example day, this is 205 trials with monoc or
% IOT presentations.
% We want 5 variables (or collumns) because we currently desire these:
%   1. Condition label: a string such as "monocular_PO_LE"
%   2. Continuous Data: (1 x sdftm) e.g. (1 x 951) with spking responses
%   3. response categorical label - transient vs sustained 
%   4. RESP bin value: RESP(1 || 2) %% 1 is transient 2 is sustained


%% Lets do some intense cognitive work
IDX.depthLabel = [];
for c = 1:4
    for d = 1:32
        if ismember(d,depths.upperBin{c})
            IDX.depthLabel{c,d} = 'U'; %U for upper
        elseif ismember(d,depths.middleBin{c})
            IDX.depthLabel{c,d} = 'M'; %M for middle
        elseif ismember(d,depths.lowerBin{c})
            IDX.depthLabel{c,d} = 'L'; %L for Lower
        else 
            IDX.depthLabel{c,d} = 'O'; % O for "out"
        end
    end
end


%% the table loop
clear forGramm trlLabel depthLabel SDF_trials SDF_trials RESPbinLabel RESPbinVal
count = 0;
for rs = 1:4
    for respBinLoop = 1:2
        for exUnit = 1:32
            for i = 1:8
                for j = 1:IDX.CondTrialNum{rs,i}
                    count = count+1;
                    trlLabel{count,:}       = IDX.conditions{i};
                    depthLabel{count,:}     = IDX.depthLabel{rs,exUnit};
                    SDF_trials{count,:}     = IDX.condSelectSDF{rs,i}(exUnit,:,j);  
                    if respBinLoop == 1
                        RESPbinLabel{count,:}   = 'Transient';
                    elseif respBinLoop == 2
                        RESPbinLabel{count,:}   = 'Sustained';
                    end
                    RESPbinVal(count,:) = IDX.condSelectRESP{rs,i}(exUnit,respBinLoop,j);  
                end
            end
        end
    end
end

forGramm = table(trlLabel,depthLabel, SDF_trials,RESPbinLabel,RESPbinVal);
structForGramm.trlLabel = trlLabel;
structForGramm.depthLabel = depthLabel;
structForGramm.SDF_trials = SDF_trials;
structForGramm.RESPbinLabel = RESPbinLabel;
structForGramm.RESPbinVal = RESPbinVal;


end