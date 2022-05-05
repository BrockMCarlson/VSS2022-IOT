function forGramm = formatForGrammInput(IDX,exUnit)
%% Format of forGramm output variable
% The desired output here is to make a (n x 4) cell array where n is the
% number of trials. In the example day, this is 205 trials with monoc or
% IOT presentations.
% We want 5 variables (or collumns) because we currently desire these:
%   1. Condition label: a string such as "monocular_PO_LE"
%   2. Continuous Data: (1 x sdftm) e.g. (1 x 951) with spking responses
%   3. RESP_transient: RESP(1)
%   4. RESP_sustained: RESP(2)

% A note of complication here... You have to do this for each indiviual
% electrode contact

%% Lets do some intense cognitive work
count = 0;
clear trlLabel SDF_trials RESP_trans RESP_sustained
for i = 1:8
    for j = 1:IDX.CondTrialNum(i)
        count = count+1;
        trlLabel{count,:}   = IDX.conditions{i};
        SDF_trials{count,:} = IDX.condSelectSDF{1,i}(exUnit,:,j);  
        RESP_trans{count,:} = IDX.condSelectRESP{1,i}(exUnit,1,j);  
        RESP_sustained{count,:} = IDX.condSelectRESP{1,i}(exUnit,2,j);  
    end
end

forGramm = table(trlLabel, SDF_trials,RESP_trans,RESP_sustained);


end