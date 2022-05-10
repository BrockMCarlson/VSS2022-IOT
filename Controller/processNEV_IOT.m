%  processNEV_IOT()
% plot PSD and CSD with NEV only - no stimulus information required

clear
close all
[RIGDIR, CODEDIR, OUTDIR_FD, OUTDIR_PLOT] = setup_IOT('BrockHome');
cd(RIGDIR)

%% Set up master table
% no .bhv file required
% Combined from analyEVP.m and analyPSDdepth_redo.m in MLAnalysisOnline31
    sessionListName = {'211008_B'; '211009_B'; '211012_B'; '211025_B'; '211027_B'; '211102_B'; '211103_B'; '211105_B'};
    lastEvpNumber.array = {4,5,3,5,2,3,4,6,4,4,5,3};
    lastEvpNumber.string = cellfun(@num2str,lastEvpNumber.array,'un',0); %turn any cell of arrays and strings into all strings
    bmcBRFSNumber.array = {1,2,1,1,2,1,1,1,1,1,1,1};
    bmcBRFSNumber.string = cellfun(@num2str,bmcBRFSNumber.array,'un',0); %turn any cell of arrays and strings into all strings

    for sessionNumber = 1:8
        EVPName{sessionNumber,1}= strcat(...
            RIGDIR,...
            sessionListName{sessionNumber},filesep,...
            sessionListName{sessionNumber},...
            '_evp00',lastEvpNumber.string{sessionNumber});
        bmcBRFSName{sessionNumber,1}= strcat(...
            RIGDIR,...
            sessionListName{sessionNumber},filesep,...
            sessionListName{sessionNumber},...
            '_bmcBRFS00',bmcBRFSNumber.string{sessionNumber});
    end
    useChans  = {1:32,1:32,1:32,1:32,1:32,1:32,1:32,1:32}';
    interpTheseChans = {[],[],[],[],[],[],[],[]}';
    FileInformationTable = table(EVPName,bmcBRFSName,useChans,interpTheseChans);






%% Automation setup 
global OUTDIR_PLOT
FolderName = strcat(OUTDIR_PLOT,'figsFrom-processNEV_IOT\');   % Your destination folder
cd(FolderName)
for sessionNumber = [1 2 3 4 6 7 8]
    holderNameEVP = FileInformationTable.EVPName{sessionNumber};
    holderNameBRFS = FileInformationTable.bmcBRFSName{sessionNumber};
    holderUseChans = FileInformationTable.useChans{sessionNumber};
    holderInterpChans = FileInformationTable.interpTheseChans{sessionNumber};
     
    plotCSDandPSDfromNEV(holderNameEVP,holderUseChans,holderInterpChans);
          FigName   = strcat(sessionListName{sessionNumber},'_EVP');
          savefig(gcf, strcat(FolderName, FigName, '.fig'));
          saveas(gcf, strcat(FolderName, FigName, '.svg'));
              saveas(gcf, strcat(FolderName, FigName, '.png'));
          close all
          
    plotCSDandPSDfromNEV(holderNameBRFS,holderUseChans,holderInterpChans);
          FigName   = strcat(sessionListName{sessionNumber},'_BRFS');
          savefig(gcf, strcat(FolderName, FigName, '.fig'));
          saveas(gcf, strcat(FolderName, FigName, '.svg'));
          saveas(gcf, strcat(FolderName, FigName, '.png'));
          close all
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

