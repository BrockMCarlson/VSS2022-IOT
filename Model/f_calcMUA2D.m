function MUA = f_calcMUA2D(DAT,Fs,method)


if nargin < 3
    method = 'default';
end

nyq = Fs/2;


switch method
    
    case 'Dec21Fix'
        lpc = 5000;  %low pass cutoff
        lWn = lpc/nyq;
        [bwb,bwa] = butter(4,lWn,'low');
        lpMUA = abs(filtfilt(bwb,bwa,DAT)); %high pass filter &rectify
        
        hpc = 500; %high pass cutoff
        hWn = hpc/nyq;
        [bwb,bwa] = butter(4,hWn,'high');
        hpMUA = abs(filtfilt(bwb,bwa,lpMUA)); 
        
        fullRectMUA = abs(hpMUA);
        
        lpc2 = lpc/2;
        lWn2 = lpc2/nyq;
        [bwb,bwa] = butter(4,lWn2,'low');
        lpMUA = abs(filtfilt(bwb,bwa,fullRectMUA)); %high pass filter &rectify
    
    case 'default'
        hpc = 750;  %high pass cutoff
        hWn = hpc/nyq;
        [bwb,bwa] = butter(4,hWn,'high');
        hpMUA = abs(filtfilt(bwb,bwa,DAT)); %high pass filter &rectify
        
        lpc = 250; %low pass cutoff
        lWn = lpc/nyq;
        [bwb,bwa] = butter(4,lWn,'low');
        lpMUA = abs(filtfilt(bwb,bwa,hpMUA));  %low pass filter to smooth 
        % Note - BMC - I think Roelfsema has a 1st lpc for reasons
        % intrinsic to what the signal means. Then they pass a second lpc
        % at 1/2 the value of the 1st lpc (i.e. lpc1 = 500, lpc2 = 250) for
        % smoothing purposes -- I'm currently unsure what the second filter
        % would do for smoothing, as I assume those signals would be taken
        % out in the first butterworth... Look into this further 4/30/20
        
% % %         lpc2 = lpc/2; %low pass cutoff
% % %         lWn2 = lpc2/nyq;
% % %         [bwb,bwa] = butter(4,lWn2,'low');
% % %         dat = filtfilt(bwb,bwa,lpMUA);
        
    case 'extralp'
         hpc = 750;  %high pass cutoff
        hWn = hpc/nyq;
        [bwb,bwa] = butter(4,hWn,'high');
        hpMUA = abs(filtfilt(bwb,bwa,DAT)); %high pass filter &rectify
        
        lpc = 50; %low pass cutoff
        lWn = lpc/nyq;
        [bwb,bwa] = butter(4,lWn,'low');
        lpMUA = filtfilt(bwb,bwa,hpMUA);  %low pass filter to smooth
                
end

MUA = lpMUA;


