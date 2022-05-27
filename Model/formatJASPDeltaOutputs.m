function DeltaForJASP = formatJASPDeltaOutputs(IDX,depths)
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
count = 0;
for c = 1:4
    for d = 1:32
        if ismember(d,depths.upperBin{c})
            count = count + 1;
            depthCategorical(count,1) = 'U'; %U for upper
            delta(count,1) = IDX.condDelta{c}(d,2); % c gets you to the penetration number, de gets you to the electrode number, and '2' gets you the sustained reponse
        elseif ismember(d,depths.middleBin{c})
            count = count + 1;
            depthCategorical(count,1) = 'M'; %U for upper
            delta(count,1) = IDX.condDelta{c}(d,2);
        elseif ismember(d,depths.lowerBin{c})
            count = count + 1;
            depthCategorical(count,1) = 'D'; %U for upper
            delta(count,1) = IDX.condDelta{c}(d,2);
        else 
%             IDX.depthLabel{c,d} = 'O'; % O for "out"
        end
    end
end



DeltaForJASP = table(depthCategorical,delta);


end