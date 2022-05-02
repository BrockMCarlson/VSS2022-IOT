function CODEDIR = setup_IOT(user)

% helper function 
% MAC, Feb 2020
global  RIGDIR AUTODIR SORTDIR ALIGNDIR IDXDIR STIMDIR  CODEDIR OUTDIR  
 

    switch user
        
        case {'BrockWork'}
            RIGDIR   = 'E:\bmcBRFSsessions\';
            CODEDIR  = 'C:\Users\Brock\Documents\MATLAB\GitHub\VSS2022-IOT\';
            IDXDIR   = 'T:\Brock - backups\Backup - WD harddrive - 220311\5 diIDX dir\';
            STIMDIR  = 'T:\Brock - backups\Backup - WD harddrive - 220311\2 all LFP STIM\';
            OUTDIR   = 'T:\Brock - backups\Backup - WD harddrive - 220311\6 Plot Dir\1.5 Gramm\outputs from 1.5 master code\NS NPS outputs\';
               
            cd(CODEDIR)
      
    
        case {'BrockHome'}
            CODEDIR  = 'C:____________________\GitHub\VSS2022-IOT';

                       
            cd(CODEDIR)
     
           
    end
      
        
end
