clear
BRdatafile = '220216_B_dotmapping001 ';
el = 'eA';
el_array = [3:32];


flag_RewardedTrialsOnly = false;
badobs = [];

flag_RFM   = true; % newer method, a bit slower [set false if line below is true]
flag_2Dfit = false; % prior method [set false if line above is true]

flag_plotNS2 = false; % set to true to get a RFmap from LFP power, requires NS2, SLOW

if ispc
    brdrname = ['\\CEREBUSHOSTPC\CerebrusData\' BRdatafile(1:8) '\']; 
    mldrname = ['\\DESKTOP-CLLHO3Q\MLData\' BRdatafile(1:8) '\'];
    
else
       brdrname     = sprintf('/users/kaciedougherty/documents/neurophysdata/%s',BRdatafile(1:8));
      mldrname     = brdrname;
  
end
dots = readgDotsXY([mldrname filesep BRdatafile '.gDotsXY_di']); % read in text file with stim parameters

clear SPK WAVE NEV
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
EventSampels = double(NEV.Data.SerialDigitalIO.TimeStamp);
[pEvC, pEvT] = parsEventCodesML(EventCodes,EventSampels);

if ~ispc & exist(strcat(filename,'.ppnev'),'file') == 2
        NEV = load(strcat(filename,'.ppnev'),'-MAT');
end
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
    if flag_plotNS2
         NS_header = openNSx(strcat(filename,'.ns2'),'noread');
         nidx = find(cell2mat(cellfun(@(x) ~isempty(strfind(x,elabel)),{NS_header.ElectrodesInfo.Label},'UniformOutput',0)));
    end 
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
        clear SPK Fs
        SPK = double(NEV.Data.Spikes.TimeStamp(I)); % in samples
        WAVE = double(NEV.Data.Spikes.Waveform(:,I));
        Fs = double(NEV.MetaTags.SampleRes);
        
        ct = 0; clear r_sua r_mua x y d eye
        trls = find(cellfun(@(x) sum(x == 23) == sum(x == 24),pEvC));
        for tr = 1:length(trls)
            t = trls(tr);
            
            if flag_RewardedTrialsOnly && ~any(pEvC{t} == 96)
                % skip if not rewarded (event code 96)
                continue
            end
            
            stimon  =  pEvC{t} == 23 | pEvC{t} == 25  | pEvC{t} == 27   | pEvC{t} == 29  | pEvC{t} == 31;
            stimoff =  pEvC{t} == 24 | pEvC{t} == 26  | pEvC{t} == 28   | pEvC{t} == 30  | pEvC{t} == 32;
            
            st = pEvT{t}(stimon);
            en = pEvT{t}(stimoff);
            stim =  find(dots.trial == t);
            
            maxpres = min([length(st) length(en) length(stim)]);
            
            for p = 1:maxpres
                ct = ct + 1;
                x(ct) = dots.dot_x(stim(p));
                y(ct) = dots.dot_y(stim(p));
                d(ct) = dots.diameter(stim(p));
                eye(ct) = dots.dot_eye(stim(p));
                if any(ct == badobs)
                    r_sua(ct) = NaN;
                    r_mua(ct) = NaN;
                else
                    r_sua(ct) = sum(SPK > st(p) & SPK < en(p)) / ((en(p)-st(p))/Fs);
                    
                    if flag_plotNS2 
                        % NS2, low-frequnecy power
                        clear timeperiod NS
                        timeperiod = sprintf('t:%u:%u', round(st(p)/Fs*1000), round(en(p)/Fs*1000));
                        channel    = sprintf('c:%u', nidx);
                        NS = openNSx(strcat(filename,'.ns2'),timeperiod,channel,...
                            'read','uV','precision','double');
                        r_mua(ct) = mean(abs(NS.Data)) / ((en(p)-st(p))/Fs);
                    else
                        r_mua(ct) = NaN;
                    end
                    
                end
                
            end
            
        end
        if ~any(r_sua)
            fprintf('\n no spikes for %s\n',elabel)
            continue
        end
        
        %figure('position', [670   554   957   424])
        figure
        subplot(2,3,1)
        plot(r_sua);
        axis tight; box off;
        xlabel('stim prez')
        ylabel('# of spikes')
        title(elabel)
        
        subplot(2,3,4)
        plot(mean(WAVE,2),'-'); hold on
        plot(mean(WAVE,2)+ std(WAVE,[],2),':'); hold on
        plot(mean(WAVE,2)- std(WAVE,[],2),':'); hold on
        xlabel('waveform')
        axis tight; box off
        
        % NOW REMOVE NANs to not messs up ct, NaNs in "r" indicate "badobs"
        x = x(~isnan(r_sua)); y = y(~isnan(r_sua)); eye = eye(~isnan(r_sua)); d = d(~isnan(r_sua));
        if flag_plotNS2
            r_mua = r_mua(~isnan(r_sua));
        end
        r_sua = r_sua(~isnan(r_sua));
        
        subplot(2,3,[2 5])
        z = round(r_sua*1000);
        map = jet(max(z)+1);
        scatter3(x,y,z,30,map(z+1,:),'LineWidth',1.5);
        xlabel('horz. cord.')
        ylabel('vertical cord.')
        zlabel('spk response')
        set(gca,'box','off','view',[-.5 90])
        title(sprintf('%s',BRdatafile),'interpreter','none')
       
        if flag_RFM
            if flag_plotNS2
                pmax = 2;
            else
                pmax = 1;
            end
            
            for p = 1:pmax
                 if p == 2
                    r_sua = r_mua;
                end
                
            clear X Y Z iZ uZ
            rfcomputation = 'halfmax';
            res = 0.05; % dva per pix in matrix
            dd = max(dots.diameter);
            [X,Y] = meshgrid(min(dots.dot_x)-dd:res:max(dots.dot_x)+dd, min(dots.dot_y)-dd:res:max(dots.dot_y)+dd);
            Z = NaN(size(X,1),size(X,2),length(dots.dot_x));
            for obs = 1:length(x)
                xx = x(obs);
                yy = y(obs);
                dd = d(obs);
                fill = sqrt(abs(X-xx).^2 + abs(Y-yy).^2) < dd/2;
                if ~any(any(fill))
                    error('check matrix')
                end
                trldat = Z(:,:,obs);
                trldat(fill) = r_sua(obs);
                Z(:,:,obs) = trldat;
            end
            % average map
            uZ = nanmean(Z,3);
            % determin boundary of RF, using half max OR t-test
            baseline  = nanmedian(r_sua);
            maxspking = max(max(uZ));
            switch rfcomputation
                case 'ttest'
                    IslandMap = ttest(Z,baseline,'dim',3,'alpha',0.001,'tail','right');
                    IslandMap(isnan(IslandMap)) = 0;
                case 'halfmax'
                    IslandMap = uZ > maxspking*0.5;
            end
            % use imagetoobox, same as PNAS
            CC = bwconncomp(IslandMap);
            [~, index] = max(cellfun('size',CC.PixelIdxList,1)); %the number of squares that surpass criteria and arein the largest connected patch
            STATS = regionprops(CC,'BoundingBox','Centroid');
            width = (STATS(index).BoundingBox(3:4) .* res) ;
            centroid = round(STATS(index).Centroid);
            centroid = [X(1,centroid(1)) Y(centroid(2),1)];
            rfboundary = [centroid(1)-width(1)/2,centroid(2)-width(2)/2, width(1), width(2)];
            %  smooth map.
            sigma = 0;%(dd/2)/3 /res;
            if sigma > 0
                iNaN = isnan(uZ);
                uZ(iNaN) = 0;
                iZ = imgaussfilt(uZ,sigma);
                iZ(iNaN) = NaN;
            else
                iZ = uZ;
            end
            % PLOT
            if flag_plotNS2
                subplot(2,3,3*p)
            else
                subplot(2,3,[3 6])
            end
            imagesc(X(1,:),Y(:,1),iZ); hold on
            r_sua = rectangle('Position',rfboundary,'Curvature',[1,1]);
            %adjust map to accomidate NaNs
            colormap jet
            map = colormap;
            cstep = range(get(gca,'CLim')) / length(map);
            set(gca,'CLim', get(gca,'CLim') + [-1*cstep 0]);
            map = [1 1 1;colormap];
            colormap(map);
            % label and scal axies
            if p == 1
            title(sprintf(...
                'Image Resolution = %0.3f dva/pix\nSigma = %0.3f pix | %0.3f dva\nRF via %s\ncenter = [%0.2f %0.2f] width = %.2f',...
                res, sigma, sigma*res, rfcomputation, centroid(1), centroid(2), mean(width)));
            elseif p == 2
                title(sprintf(...
                'LFP POWER\ncenter = [%0.2f %0.2f] width = %.2f',...
                centroid(1), centroid(2), mean(width)));
            end
            uRF(:,:,i) = [centroid(1),centroid(2)];
            uWidth(:,i) = mean(width);
            set(gca,'Ydir','normal','Box', 'off')
            xlabel('horz. cord.')
            ylabel('vertical cord.')
            grid on
            end
            
        elseif flag_2Dfit
            subplot(2,3,[3 6])
            fitstr = 'cubicinterp';%;'cubicinterp';
            f = fit([x', y'],r_sua',fitstr);
            h = plot(f,[x', y'],r_sua');
            xlabel('horz. cord.')
            ylabel('vertical cord.')
            set(h(1),'FaceAlpha',1,'EdgeColor','none')
            set(h(2),'Marker','none')
            set(gca,'box','off','view',[0 90])
            c = colorbar('Location','NorthOutside');
            xlabel(c,sprintf('fit (%s)',fitstr))
            grid on
            colormap jet
        end 
         cd('C:\Users\maierlab\desktop\plots\')
        %saveas(gcf,sprintf('%s_%s%02u',BRdatafile,el,el_array(i)),'eps2c'); 

    end
end



