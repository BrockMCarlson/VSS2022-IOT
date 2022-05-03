clear
close all
%BRdatafile = '211003_T_rfori004';
BRdatafile = '220214_B_rfori4lesions001';
PHASE = [0];
el = 'eA';
el_array = [5:32];

flag_RewardedTrialsOnly = false;
badobs = [];

if ispc
    brdrname = ['\\CEREBUSHOSTPC\CerebrusData\' BRdatafile(1:8) '\']; 
    mldrname = ['\\DESKTOP-CLLHO3Q\MLData\' BRdatafile(1:8) '\']; %IP  changed 9/25/2021 by BMC and BAM in prep for V1 B-52 recordings
    %mldrname = ['\\129.59.122.114\MLData\' BRdatafile(1:8) '\']; 
    %mldrname = ['T:\rig021 BMC_BAM 2021 B-52 V1 recordings\rig021 MonkeyLogic files for online analysis\' BRdatafile(1:8) '\']; 
     %brdrname = ['T:\rig021 BMC_BAM 2021 B-52 V1 recordings\rig021 BlackRock files for online analysis\' BRdatafile(1:8) '\']; 

else
    if ~isempty(strfind(BRdatafile,'_I_'))
        rignum = '021';
    else
        rignum = '022';
    end
    brdrname = sprintf('/Volumes/Drobo/DATA/NEUROPHYS/rig%s/%s',rignum,BRdatafile(1:8));
    mldrname = brdrname;
end

if ~isempty(strfind(BRdatafile,'oridrft'))
    ext = '.gRFORIDRFTGrating_di';
    elseif ~isempty(strfind(BRdatafile,'lesions'))
    ext = '.gRFORI4LESIONSGrating_di';
elseif ~isempty(strfind(BRdatafile,'ori'))
    ext = '.gRFORIGrating_di';
elseif ~isempty(strfind(BRdatafile,'sf'))
    ext = '.gRFSFGrating_di';
elseif  ~isempty(strfind(BRdatafile,'size'))
    ext = '.gRFSIZEGrating_di';

end

%if ~isempty(strfind(BRdatafile,'drft'))
   % grating = readgDRFTGrating([mldrname filesep BRdatafile ext]);
%else
grating = readgGrating([mldrname BRdatafile ext]); % removed filesep after mldrname
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load digital codes and neural data:
filename = fullfile(brdrname,BRdatafile);

% check if file exist and load NEV
if exist(strcat(filename,'.nev'),'file') == 2
    NEV = openNEV(strcat(filename,'.nev'),'read','overwrite','uV');
else
    error('the following file does not exist\n%s.nev',filename);
end
% get event codes from NEV
EventCodes = NEV.Data.SerialDigitalIO.UnparsedData - 128;
EventTimes = floor(NEV.Data.SerialDigitalIO.TimeStampSec .* 1000); %ms, to match 1kHz
EventSampels = NEV.Data.SerialDigitalIO.TimeStamp;
% % [pEvC, pEvT] = parsEventCodesML(EventCodes,EventSampels);
[pEvC, pEvT] = parsEventCodesML(EventCodes,EventSampels);

% check that all is good between NEV and grating text file;
% [allpass, message] =  checkTrMatch(grating,NEV);
% if ~allpass
%     error('not all pass')
% end
%%
% sort/pick trials [before iterating units]
stimfeatures = {...
    'tilt'...
    'sf'...
    'contrast'...
    'fixedc'...
    'diameter'...
    'eye'...
    'varyeye'...
    'oridist'...
    'gabor'...
    'gabor_std'...
    'phase'...
    };
clear(stimfeatures{:})

obs = 0; clear spkTPs STIM
for t = 1: length(pEvC)
    
    stimon  =  pEvC{t} == 23 | pEvC{t} == 25  | pEvC{t} == 27   | pEvC{t} == 29  | pEvC{t} == 31;
    stimoff =  pEvC{t} == 24 | pEvC{t} == 26  | pEvC{t} == 28   | pEvC{t} == 30  | pEvC{t} == 32;
    
    st = pEvT{t}(stimon);
    en = pEvT{t}(stimoff);
    
    stim =  find(grating.trial == t); if any(diff(stim) ~= 1); error('check grating file'); end
    
    for p = 1:length(en)
        obs = obs + 1;
        
        if  any(obs == badobs) || ...
                (flag_RewardedTrialsOnly && ~any(pEvC{t} == 96))
            
            spkTPs(obs,:) = [0 0];
            for f = 1:length(stimfeatures)
                STIM.(stimfeatures{f})(obs,:) = NaN;
            end
        else
            
            spkTPs(obs,:) = [st(p) en(p)];
            for f = 1:length(stimfeatures)
                STIM.(stimfeatures{f})(obs,:) = grating.(stimfeatures{f})(stim(p));
            end
        end
    end
end % looked at all trials

%%

if isempty(el_array)
    nel = 1;
else
    nel = length(el_array);
end

for i = 1:nel
    e = el_array(i);
    
    % get electrrode index
    if isempty(el_array)
        elabel = el;
    else
        elabel = sprintf('%s%02u',el,e);
    end
    eidx = find(cell2mat(cellfun(@(x) ~isempty(strfind(x',elabel)),{NEV.ElectrodesInfo.ElectrodeLabel},'UniformOutput',0)));
    if isempty(eidx)
        error('no %s',elabel)
    end
    eI =  NEV.Data.Spikes.Electrode == eidx;
    units = unique(NEV.Data.Spikes.Unit(eI));
    for u = 0:max(units)
        if u > 0
            elabel = sprintf('%s%02u - unit%u',el,e,u);
            I = eI &  NEV.Data.Spikes.Unit == u;
        else
            elabel = sprintf('%s%02u - all spikes',el,e);
            I = eI;
        end
        
        % get SPK and WAVE
        clear SPK WAVE RESP
        SPK = double(NEV.Data.Spikes.TimeStamp(I)); % in samples
        WAVE = double(NEV.Data.Spikes.Waveform(:,I));
        RESP = NaN(length(spkTPs),1);
        
        for r = 1:length(spkTPs)
            st = spkTPs(r,1);
            en = spkTPs(r,2);
            if st ~= 0 && en ~= 0
                RESP(r,:) = sum(SPK > st & SPK < en);
            end
        end
        
        
        
        
        if ~any(RESP)
            continue
        end
        
        uEye=unique(STIM.eye);
        rows = 1 + length(uEye);
        
        figure
        subplot(rows,3,1)
        plot(RESP);
        axis tight; box off;
        xlabel('obs ct')
        ylabel('# of spikes')
        if isempty(PHASE)
            title(sprintf('%s\n All Phases',elabel))
        else
            title(sprintf('%s\nPhase = %0.2f',elabel,PHASE))
        end
        
        subplot(rows,3,2)
        hist(RESP);
        box off;
        xlabel('# of spikes')
        ylabel('frequency')
        title(BRdatafile,'interpreter','none')
        
        
        subplot(rows,3,3)
        plot(mean(WAVE,2),'-'); hold on
        plot(mean(WAVE,2)+ std(WAVE,[],2),':'); hold on
        plot(mean(WAVE,2)- std(WAVE,[],2),':'); hold on
        xlabel('waveform')
        axis tight; box off
        
        
         
         for j = 1:length(uEye)
             EYE = uEye(j);
        clear resp feature x y f
        header = grating.header{1};
        switch header
            case {'rfori','rfori4lesions'}
                if ~isempty(PHASE)
                    resp = RESP(STIM.eye==EYE & STIM.phase == PHASE);
                    feature = STIM.tilt(STIM.eye==EYE & STIM.phase == PHASE);
                else
                    resp = RESP(STIM.eye==EYE);
                    feature = STIM.tilt(STIM.eye==EYE);
                end
                [uR sR gname n] = grpstats(resp,feature, {'mean','sem','gname','numel'});
                y = uR;
                x = cellfun(@(x) str2num(x),gname);
                y = [y; y];
                x = [x ; x+180];
                err = [sR; sR];
                f = fit(x,y,'smoothingspline');
                
                % SPECIAL PLOT
                subplot(rows,3,6 + 3*(j-1))
                theta = deg2rad(feature);
                roh = resp;
                polar(theta, roh,'bx'); hold on
                polar(theta+pi, roh,'bx'); hold on
                [uRoh mRoh uTheta n] = grpstats(roh, theta, {'mean','median','gname','numel'});
                uTheta = str2double(uTheta);
                polar(uTheta, uRoh,'r.'); hold on
                polar(uTheta+pi, uRoh,'r.'); hold on
                polar(uTheta, mRoh,'go'); hold on
                polar(uTheta+pi, mRoh,'go'); hold on
                title(sprintf('n = [%u %u]',min(n), max(n)))
                axis tight; axis square; box off;
                
            case 'rfsf'
                if ~isempty(PHASE)
                    resp = RESP(STIM.eye==EYE & STIM.phase == PHASE);
                    feature = STIM.sf(STIM.eye==EYE & STIM.phase == PHASE);
                else
                    resp = RESP(STIM.eye==EYE);
                    feature = STIM.sf(STIM.eye==EYE);
                end
                [uR sR gname n] = grpstats(resp,feature, {'mean','sem','gname','numel'});
                y = uR;
                x = cellfun(@(x) str2num(x),gname);
                f = fit(x,y,'smoothingspline');
                err = sR;
                
            case 'rfsize'
                resp = RESP(STIM.eye==EYE);
                feature = STIM.diameter(STIM.eye==EYE);
                [uR sR gname n] = grpstats(resp,feature, {'mean','sem','gname','numel'});
                y = uR;
                x = cellfun(@(x) str2num(x),gname);
                f = fit(x,y,'smoothingspline');
                err = sR;
                
        end
        
        subplot(rows,3,4 + 3*(j-1))
        boxplot(resp,feature)
        p=anovan(resp,feature,'display','off');
        title(sprintf('p = %0.3f,',p))
        xlabel(header)
        ylabel(sprintf('Eye = %u',EYE))
        axis tight; box off;
        
        subplot(rows,3,5 +  3*(j-1))
        plot(f,x,y); hold on
        errorbar(x,y,err,'linestyle','none'); hold on
        axis tight; axis square; box off; legend('off')
        set(gcf, 'Position', [104 160 560 1104]);
        
        switch header
            case 'rfori'
                plot([180 180],ylim,'k:');
        end
         end
    end
end




%%
% figure;
% subplot(1,2,1)
% plot(R);
% axis tight; box off;
% subplot(1,2,2)
% hist(R);
% axis tight; box off;
% title(elabel)
%
%
%
%
%


