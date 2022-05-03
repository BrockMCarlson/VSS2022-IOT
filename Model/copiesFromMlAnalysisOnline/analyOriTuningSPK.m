
BRdatafile = '220110_B_rfori002';
EYE =[1]; % 1 - both, 2 - right eye only, 3 - left eye only

if ispc
    %brdrname = sprintf('Z:\\%s',BRdatafile(1:8));
    %mldrname = sprintf('Y:\\%s',BRdatafile(1:8));
    brdrname = ['\\CEREBUSHOSTPC\CerebrusData\' BRdatafile(1:8) '\']; 
    mldrname = ['\\DESKTOP-CLLHO3Q\MLData\' BRdatafile(1:8) '\'];
else
    brdrname = sprintf('/Volumes/Drobo/DATA/NEUROPHYS/rig022/%s',BRdatafile(1:8));
    mldrname = brdrname;
end
grating   = readgGrating([mldrname filesep BRdatafile '.gRFORIGrating_di']);


badobs = getBadObs(BRdatafile);

clear SPK WAVE NEV
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% load digital codes and neural data:
filename = fullfile(brdrname,BRdatafile);

% check if file exist and load NEV
if exist(strcat(filename,'.nev'),'file') == 2;
    NEV = openNEV(strcat(filename,'.nev'),'read','overwrite','uV');
else
    error('the following file does not exist\n%s.nev',filename);
end
% get event codes from NEV
EventCodes = NEV.Data.SerialDigitalIO.UnparsedData - 128;
EventTimes = floor(NEV.Data.SerialDigitalIO.TimeStampSec .* 1000); %ms, to match 1kHz
EventSampels = NEV.Data.SerialDigitalIO.TimeStamp;
[pEvC, pEvT] = parsEventCodesML(EventCodes,EventSampels);

for e = 1:24
    disp(e)
    
    % get electrrode index
    elabel = sprintf('eD%02u',e);
    eidx = find(cell2mat(cellfun(@(x) ~isempty(strfind(x',elabel)),{NEV.ElectrodesInfo.ElectrodeLabel},'UniformOutput',0)));
    if isempty(eidx)
        error('no %s',elabel)
    end
    eI =  NEV.Data.Spikes.Electrode == eidx;
    units = un0que(NEV.Data.Spikes.Unit(eI));
    for u = 0:max(units)
        if u > 0
            elabel = sprintf('eD%02u - unit%u',e,u);
            I = eI &  NEV.Data.Spikes.Unit == u;
        else
            elabel = sprintf('eD%02u - all spikes',e);
            I = eI;
        end
        
        % get SPK and WAVE
        clear SPK Fs
        SPK = double(NEV.Data.Spikes.TimeStamp(I)); % in samples
        WAVE = double(NEV.Data.Spikes.Waveform(:,I));
        %Fs = double(NEV.MetaTags.SampleRes);
        
        
        
        ct = 0; clear r tilt eye oridist
        trls = find(cellfun(@(x) sum(x == 23) == sum(x == 24),pEvC));
        for i = 1:length(trls)
            t = trls(i);
            %         if t == 1 ||  ~any(pEvC{t} == 96)
            %             % often have issuesd on 1st trial
            %             continue
            %         end
            stimon  =  pEvC{t} == 23 | pEvC{t} == 25  | pEvC{t} == 27   | pEvC{t} == 29  | pEvC{t} == 31;
            stimoff =  pEvC{t} == 24 | pEvC{t} == 26  | pEvC{t} == 28   | pEvC{t} == 30  | pEvC{t} == 32;
            
            st = pEvT{t}(stimon);
            en = pEvT{t}(stimoff);
            stim =  find(grating.trial == t);
            for p = 1:length(en)
                ct = ct + 1;
                if any(ct == badobs)
                    r(ct) = NaN;%sum(SPK > st(p) & SPK < en(p));
                    tilt(ct) = NaN;%grating.tilt(stim(p));
                    eye(ct) = NaN;%grating.eye(stim(p));
                    oridist(ct) = NaN;%grating.oridist(stim(p));
                else
                    r(ct) = sum(SPK > st(p) & SPK < en(p));
                    tilt(ct) = grating.tilt(stim(p));
                    eye(ct) = grating.eye(stim(p));
                    oridist(ct) = grating.oridist(stim(p));
                end
            end
            
        end
        if ~any(r)
            continue
        end
        
        
        teye = eye*1000 + tilt;
        teo = eye*1000 + tilt.*oridist;
        group = 'tilt';
        
        figure%('Position',[ 11         558        1904         420])
        subplot(2,3,1)
        plot(r);
        axis tight; box off;
        xlabel('stim prez')
        ylabel('# of spikes')
        title(elabel)
        
        subplot(2,3,2)
        hist(r);
        box off;
        xlabel('# of spikes')
        ylabel('frequency')
        
        subplot(2,3,3)
        plot(mean(WAVE,2),'-'); hold on
        plot(mean(WAVE,2)+ std(WAVE,[],2),':'); hold on
        plot(mean(WAVE,2)- std(WAVE,[],2),':'); hold on
        xlabel('waveform')
        axis tight; box off
        
        subplot(2,3,4)
        boxplot(r(eye==EYE),tilt(eye==EYE))
        p=anovan(r(eye==EYE),tilt(eye==EYE)','display','off');
        %     boxplot(r,tilt)
        %     p=anovan(r,tilt','display','off');
        title(sprintf('p = %0.3f,',p))
        xlabel(group)
        ylabel('# of spikes')
        axis tight; box off;
        
        
        subplot(2,3,5)
        theta = deg2rad(tilt(eye==EYE));
        roh = r(eye==EYE);
        
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
        
        subplot(2,3,6)
        clear x y f
        [uR sR uTilt n] = grpstats(r(eye==EYE), tilt(eye==EYE), {'mean','sem','gname','numel'});
        y = uR;
        x = cellfun(@(x) str2num(x),uTilt);
        y = [y; y];
        x = [x ; x+180];
        f = fit(x,y,'smoothingspline');
        plot(f,x,y); hold on
        errorbar(x,y,[sR; sR],'linestyle','none'); hold on
        axis tight; axis square; box off; legend('off')
        plot([180 180],ylim,'k:');
        
        
        
        
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


