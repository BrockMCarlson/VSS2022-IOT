function CODEDIR = PostSetup(user)

% helper function 
% MAC, Feb 2020
global HOMEDIR NS6DIR AUTODIR SORTDIR ALIGNDIR IDXDIR STIMDIR SAVEDIR CODEDIR OUTDIR tasks LFPDIR
 

    switch user
        
        case {'BrockWork'}
            NS6DIR   = 'T:\Brock - backups\Backup - WD harddrive - 220311\1 brfs ns6 files\';
            CODEDIR  = 'C:\Users\Brock\Documents\MATLAB\GitHub\VSS2022-IOT';
            IDXDIR   = 'T:\Brock - backups\Backup - WD harddrive - 220311\5 diIDX dir\';
            STIMDIR  = 'T:\Brock - backups\Backup - WD harddrive - 220311\2 all LFP STIM\';
            OUTDIR   = 'T:\Brock - backups\Backup - WD harddrive - 220311\6 Plot Dir\1.5 Gramm\outputs from 1.5 master code\NS NPS outputs\';
            LFPDIR   = [];
               
            cd(CODEDIR)
      
    
        case {'BrockHome'}
            CODEDIR  = 'C:____________________\GitHub\VSS2022-IOT';

                       
            cd(CODEDIR)
     
           
    end
      
        
end
