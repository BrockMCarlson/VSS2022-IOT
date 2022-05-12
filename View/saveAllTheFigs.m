%% Save all the figs
function saveAllTheFigs(figNameList,FolderName)
% Example inputs
% % figNameList = {'Lam_Sus','Lam_Trans','TransVsSus','allContactLine','Lam_Line'};
% % FolderName = strcat(OUTDIR_PLOT,'figsFrom-visWithGramm_IOT\');   % Your destination folder

%
global OUTDIR_PLOT  
cd(OUTDIR_PLOT)
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = figNameList{iFig};
  savefig(FigHandle, strcat(FolderName, FigName, '.fig'));
  saveas(FigHandle, strcat(FolderName, FigName, '.svg'));

end
