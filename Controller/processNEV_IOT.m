%  processNEV_IOT()

clear
close all
setup_IOT('BrockHome')

%% Plot CSD and PSD with NEV 
% no .bhv file required
% Combined from analyEVP.m and analyPSDdepth_redo.m in MLAnalysisOnline31

%Manual Variable inputs\
    FileOfInterest = '211008_B';
    evpNumber = {'1'}';
    useChans  = {1:32};
    interpTheseChans = {[]}';
    useSession        = [true];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global RIGDIR
    cd(RIGDIR)
    FileLocation    = strcat(RIGDIR,FileOfInterest,filesep);
    dirDetails = dir(FileLocation);
    for i = 1:size(evpNumber,1)
        fullFileName(i) = strcat(FileLocation, FileOfInterest,'_bmcBRFS00',evpNumber(i));
    end
    FileInformation = table(evpNumber,useChans,interpTheseChans,fullFileName);
    clearvars -except FileInformation

clear i
for i = 1:size(FileInformation,1)
    singleFileInfo = FileInformation(i,:);
    plotCSDandPSDfromNEV(singleFileInfo)
end


%% Plot CSD and PSD with NEV 
% no .bhv file required
% Combined from analyEVP.m and analyPSDdepth_redo.m in MLAnalysisOnline31

%Manual Variable inputs\
    FileOfInterest = '211008_B';
    evpNumber = {'1','2','3','4'}';
    useChans  = {1:32; 1:32; 1:32; 1:32};
    interpTheseChans = {[],[],[],[]}';
    useSession        = [true; true; true; true];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global RIGDIR
    cd(RIGDIR)
    FileLocation    = strcat(RIGDIR,FileOfInterest,filesep);
    dirDetails = dir(FileLocation);
    for i = 1:size(evpNumber,1)
        fullFileName(i,1) = strcat(FileLocation, FileOfInterest,'_evp00', evpNumber(i));
    end
    FileInformation = table(evpNumber,useChans,interpTheseChans,fullFileName);
    clearvars -except FileInformation

clear i
for i = 1:size(FileInformation,1)
    singleFileInfo = FileInformation(i,:);
    plotCSDandPSDfromNEV(singleFileInfo)
end

%% Save all the figs
global OUTDIR_PLOT  
cd(OUTDIR_PLOT)
figNameList = {'evp4','evp3','evp2','evp1','brfs'};

FolderName = strcat(OUTDIR_PLOT,'figsFrom-processNEV_IOT\');   % Your destination folder
FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig);
  FigName   = figNameList{iFig};
  savefig(FigHandle, strcat(FolderName, FigName, '.fig'));
  saveas(FigHandle, strcat(FolderName, FigName, '.svg'));

end



%% Some notes for later

% 211008_B
% 211009_B
% 211012_B
% 211025_B
% 211027_B
% 211102_B
% 211103_B
% 211105_B
% 211208_B
% 211210_B
% 211213_B
% 211217_B

