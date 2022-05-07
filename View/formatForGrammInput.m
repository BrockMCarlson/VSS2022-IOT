function forGramm = formatForGrammInput(IDX,depths)
%% Format of forGramm output variable
% The desired output here is to make a (n x 4) cell array where n is the
% number of trials. In the example day, this is 205 trials with monoc or
% IOT presentations.
% We want 5 variables (or collumns) because we currently desire these:
%   1. Condition label: a string such as "monocular_PO_LE"
%   2. Continuous Data: (1 x sdftm) e.g. (1 x 951) with spking responses
%   3. RESP_transient: RESP(1)
%   4. RESP_sustained: RESP(2)


%% Lets do some intense cognitive work
for d = 1:32
    if ismember(d,depths.upperBin)
        IDX.depthLabel(d) = 'U'; %U for upper
    elseif ismember(d,depths.middleBin)
        IDX.depthLabel(d) = 'M'; %M for middle
    elseif ismember(d,depths.lowerBin)
        IDX.depthLabel(d) = 'L'; %L for Lower
    else 
        IDX.depthLabel(d) = 'O'; % O for "out"
    end
end

%% the table loop
count = 0;
clear trlLabel SDF_trials RESP_trans RESP_sustained
for exUnit = 1:32
    for i = 1:8
        for j = 1:IDX.CondTrialNum(i)
            count = count+1;
            trlLabel{count,:}       = IDX.conditions{i};
            depthLabel{count,:}     = IDX.depthLabel(exUnit);
            SDF_trials{count,:}     = IDX.condSelectSDF{1,i}(exUnit,:,j);  
            RESP_trans{count,:}     = IDX.condSelectRESP{1,i}(exUnit,1,j);  
            RESP_sustained{count,:} = IDX.condSelectRESP{1,i}(exUnit,2,j);  
        end
    end
end

forGramm = table(trlLabel,depthLabel, SDF_trials,RESP_trans,RESP_sustained);


end