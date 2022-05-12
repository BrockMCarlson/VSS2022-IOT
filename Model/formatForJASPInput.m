function forJASP = formatForJASPInput(forGramm)
findRows.transMonoc = strcmp(forGramm.trlLabel,'monocular_PO_DE') ...
    & strcmp(forGramm.RESPbinLabel, 'Transient');
findRows.transIOT = strcmp(forGramm.trlLabel,'IOT_PO_DE') ...
    & strcmp(forGramm.RESPbinLabel, 'Transient');
findRows.sustMonoc = strcmp(forGramm.trlLabel,'monocular_PO_DE') ...
    & strcmp(forGramm.RESPbinLabel, 'Sustained');
findRows.sustIOT= strcmp(forGramm.trlLabel,'IOT_PO_DE') ...
    & strcmp(forGramm.RESPbinLabel, 'Sustained');

fields = fieldnames(findRows);
for i = 1:size(fields,1)
    rowSums{i} = sum(findRows.(fields{i}))
end

transMonoc = forGramm.RESPbinVal(findRows.transMonoc);
transIOT = forGramm.RESPbinVal(findRows.transIOT);
sustMonoc = forGramm.RESPbinVal(findRows.sustMonoc);
sustIOT = forGramm.RESPbinVal(findRows.sustIOT);

cropSamples = min([size(transMonoc,1), size(transIOT,1)]);

forJASP = table(transMonoc(1:cropSamples),transIOT(1:cropSamples),...
    sustMonoc(1:cropSamples),sustIOT(1:cropSamples));

forJASP.Properties.VariableNames = {'transMonoc','transIOT',...
    'sustMonoc','sustIOT'};

global OUTDIR_FD
cd(OUTDIR_FD)
writetable(forJASP)

end