function [RESP, win_ms, SDF, sdftm, PSTH, psthtm] = trialAlignData_IOT(STIM,datatype,flag_1kHz,win_ms)


if nargin < 4 || isempty(win_ms)
    win_ms    = [50 100; 150 250; 50 250; -50 0]; % ms;
    % note, when win_ms exceeds stimulus duration, data will be trunkated
end
if nargin < 3 || isempty(flag_1kHz)
    flag_1kHz = true;
end
%%%%%%%%%%%%%%%%%%%%%


%% 1. Setup for this penetration   
if ~any(strcmp({'auto','nev','kls','csd','mua','lfp'},datatype))
    % auto = discreat mua, stolen from blackrock
    % mua  = analong mua, a la super
    error('bad datatype')
end

tfdouble = isa(STIM.tp_pt,'double');
if ~tfdouble
    warning('Expecting STIM.tp_pt to be a double but it is not. Unexpected behavior possible.')
end

global AUTODIR
if ~isempty(AUTODIR)
    autodir = AUTODIR;
else
    autodir = '/Volumes/Drobo2/DATA/NEUROPHYS/AutoSort-ed/';
end
global SORTDIR
if ~isempty(SORTDIR)
    sortdir = SORTDIR;
else
    sortdir = '/Volumes/Drobo2/DATA/NEUROPHYS/KiloSort-ed/';
end

bin_ms    = 10;
nwin      = size(win_ms,1);


nel = 32;
warning('nel hard-coded to 32')
clear j
el_labels = {'eA01','eA02','eA03','eA04','eA05','eA06','eA07','eA08',...
    'eA09','eA10','eA11','eA12','eA13','eA14','eA15','eA16','eA17',...
    'eA18','eA19','eA20','eA21','eA22','eA23','eA24','eA25','eA26',...
    'eA27','eA28','eA29','eA30','eA31','eA32'};
warning('el_labels hard-coded')


%% 2.  Preallocate nans for all datatypes (sdftm and triggering is setup)
    Fs = 30000;
    TP = STIM.tp_pt;
    
    RESP      = nan(nel,nwin,length(STIM.tp_pt));
    
    bin_sp    = bin_ms/1000*Fs;
    psthtm    = [-0.3*Fs : bin_sp : 0.15*Fs + max(diff(TP,[],2)) + bin_sp];
    PSTH      = nan(nel,length(psthtm),length(STIM.tp_pt));
    
    if ~flag_1kHz
        r = 1;
    else
        r = 30;
    end
    sdftm     = [-0.3*Fs/r: 0.15*Fs/r + max(diff(TP,[],2)/r)];
    SDF       = nan(nel,length(sdftm),length(STIM.tp_pt));
    SUA       = nan(nel,length(sdftm),length(STIM.tp_pt));
    k         = jnm_kernel( 'psp', (20/1000) * (Fs/r) );

        



%% 3. Load in data, overwriting NaNs to all output formats (SDF, PSTH, etc)
% Iterate trials, loading files as you go
for i = 1:length(STIM.trl)
    
    if i == 1 
        
        clear  filename BRdatafile
        filename  = STIM.fullFileName;
        [~,BRdatafile,~] = fileparts(filename);
        
        % setup SPK cell array
        SPK   = cell(nel,1);
        empty = false(size(SPK)); 
        

                clear ns6file ns_header
                ns6file    = [filename '.ns6'];
                ns_header  = openNSx(ns6file,'noread');
                
                clear elb idx e
                elb = cellfun(@(x) (x(1:4)),{ns_header.ElectrodesInfo.Label},'UniformOutput',0);
                idx = zeros(1,nel);
                for e = 1:nel
                    idx(e) = find(strcmp(elb,el_labels{e}));
                end
    end
   
    
    % get TP and rwin
    clear tp rwin
    tp = TP(i,:) ; % TP is always Fs = 30000 because it is recorded by NEV
    if any(isnan(tp))
        continue
    end
    
    rwin = tp(1) + (win_ms/1000*Fs);
    % deal with instnaces where the window exceeds stimulus offset
    stimoff = rwin > tp(2); 
    rwin(stimoff)  = tp(2); 
    
 
    %% Setup and use of f_calcMUA2D
    clear samplenum samplevec
    samplenum = tp(1) + r.*[sdftm(1) sdftm(end)];
    samplevec = samplenum(1):samplenum(end);
    
    if samplenum(end) > ns_header.MetaTags.DataPoints
        warning('Data from this timepoint has a larger samplenumber than the largest found in ns_header.MetaTags.Datapoints')
%         continue
    end
    

    clear NS dat dat0 dat1 timeperiod hpMUA lpMUA 
    timeperiod = sprintf('t:%u:%u',samplenum);
    NS = openNSx(ns6file,timeperiod,...
        'read','sample');

    dat0 = double((NS.Data(idx,:)))';  clear NS;
    trim = 1 + (length(dat0)-length(samplevec)); 
    dat  = f_calcMUA2D(dat0(trim:end,:),Fs,'Dec21Fix');
    
    if length(dat) ~= length(samplevec)
        error('lengths do not match'); 
    end
    
%             hpMUA = filtfilt(bwb1,bwa1,dat0);
%             lpMUA = abs( filtfilt( bwb2, bwa2, hpMUA ) );
%             dat = filtfilt( bwb3, bwa3, lpMUA ) ./ 4;
%             
    for w = 1:nwin
        if rwin(w,1) == rwin(w,2)
            continue
        end
        tmlim = samplevec >= rwin(w,1)  & samplevec <= rwin(w,2); 
        RESP(:,w,i) = nanmean(dat(tmlim,:),1);
    end
     
    if r > 1
        mua = downsample(dat,r); clear dat
    else 
        mua = dat; clear dat
    end
    mua(sdftm > diff(tp/r),:) = [];
    SDF(:,1:length(mua),i) = mua';
     

             
end % done iterating trials

%% 4. Cut/trim so that everything lines up.
% remove last bin (inf) and center time vector


% convert time vector to seconds
sdftm = sdftm./(Fs/r);


% trim SDF of convolution extreams %MAY NEED DEV
trim = sdftm < -0.15 | sdftm > sdftm(end) -0.15;
sdftm(trim) = [];
SDF(:,trim,:) = [];



