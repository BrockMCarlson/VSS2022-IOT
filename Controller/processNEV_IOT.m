%  processNEV_IOT()

clear
setup_IOT('BrockWork')

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




% {'211008',... 
% '211009',...
% '211012',...
% '211025',...
% '211027',...
% '211102',...
% '211103',...
% '211105',...
% '211208',...
% '211210',...
% '211213',...
% '211217'}'













% % % %  processNEV_IOT() - when you want to process all evps
% % % clear
% % % setup_IOT('BrockWork')
% % % 
% % % %% Plot CSD and PSD with NEV 
% % % % no .bhv file required
% % % % Combined from analyEVP.m and analyPSDdepth_redo.m in MLAnalysisOnline31
% % % 
% % % %Manual Variable inputs\
% % %     FileOfInterest = '211008_B';
% % %     evpNumber = {'1','2','3','4'}';
% % %     useChans  = {1:32; 1:32; 1:32; 1:32};
% % %     interpTheseChans = {[],[],[],[]}';
% % %     useSession        = [true; true; true; true];
% % %     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %     global RIGDIR
% % %     cd(RIGDIR)
% % %     FileLocation    = strcat(RIGDIR,FileOfInterest,filesep);
% % %     dirDetails = dir(FileLocation);
% % %     for i = 1:size(evpNumber,1)
% % %         fullFileName(i,1) = strcat(FileLocation, FileOfInterest,'_evp00', evpNumber(i));
% % %     end
% % %     FileInformation = table(evpNumber,useChans,interpTheseChans,fullFileName);
% % %     clearvars -except FileInformation
% % % 
% % % clear i
% % % for i = 1:size(FileInformation,1)
% % %     singleFileInfo = FileInformation(i,:);
% % %     plotCSDandPSDfromNEV(singleFileInfo)
% % % end
% % % 
