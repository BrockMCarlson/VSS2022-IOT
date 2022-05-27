function [RIGDIR, CODEDIR, OUTDIR_FD, OUTDIR_PLOT] = setup_IOT(user)
% RIGDIR        - where the base data is stored
% CODEDIR       - where your GitHub Repo is stored:
%                   this function also CDs into this directrory
% OUTDIR_FD     - FD = "Formatted Data"
%                   this is where your preProcessed / organized data goes
% OUTDIR_PLOT   - where your figures end up


global RIGDIR CODEDIR OUTDIR_FD OUTDIR_PLOT

    switch user
        case {'BrockWork'}
            RIGDIR      = 'E:\bmcBRFSsessions\';
            CODEDIR     = 'C:\Users\Brock\Documents\MATLAB\GitHub\VSS2022-IOT\';
            OUTDIR_FD   = 'C:\Users\Brock\Documents\MATLAB\formattedDataOutputs\';
            OUTDIR_PLOT = 'E:\plotData\';

        case {'BrockHome'}
            RIGDIR      = 'E:\bmcBRFSsessions\';
            CODEDIR     = 'C:\Users\Brock Carlson\Documents\GitHub\VSS2022-IOT\';
            OUTDIR_FD   = 'E:\formattedDataOutputs\';
            OUTDIR_PLOT = 'E:\plotData\';

    end
      
cd(CODEDIR)
end


% cd(RIGDIR)
% cd(CODEDIR)
% ○
% cd(OUTDIR_PLOT)
