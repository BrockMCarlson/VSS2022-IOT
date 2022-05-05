dddftedunction forGramm = formatForGrammInput(IDX)

%% Initial variables
conditNameForCC = IDX.conditions;

clear DataForVis
count = 0;
for condLabel = 1:size(conditNameForCC,1)
    for 
    count = count + 1;
    % Categoricals - IVs
    if condLabel == 1
        DataForVis.condLabel{count} = 'Monocular';
    elseif condLabel == 5
        DataForVis.condLabel{count} = 'Binocular';
    elseif condLabel == 7
        DataForVis.condLabel{count} = 'Dichoptic';
    elseif condLabel == 8
        DataForVis.condLabel{count} = 'Dichoptic';
    end

    % DV - SDF
    if isempty(IDX.allV1(uct).SDF_avg{condLabel}) || any(isnan(IDX.allV1(uct).SDF_avg{condLabel}(1:560)'))
        %            DataForVis.SDF{count,1} = nan(1,size(TM,2));
        count = count - 1; %dont count it - rewrite over variable
    else
        DataForVis.SDF{count,1} = IDX.allV1(uct).SDF_avg{condLabel}(1:560)';
    end

end



end