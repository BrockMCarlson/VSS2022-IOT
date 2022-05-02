function [newTP,trigger] = photoReTriggerSTIM_bhv2Format(TP,filename,ypos,trigger)

% TP = obs x [st en] in SAMPELS
% filename = full address, no extension, must contain path to BHV and NS6 
% ypos = location of stimulus on screen, can be scaler or same length at TP
% Oct 14th, 2021 - BM, This is not correctly being used. 


photolabel = 'ainp1';
thresh     = 3; 
nr         = 1; % see note at line 111
newTP = nan(size(TP)); 

if nargin < 4
    trigger = [];
end
if nargin < 3
    ypos = 0; 
end

if length(ypos) == 1 
    x=ypos; 
    ypos = zeros(length(TP),1); 
    ypos(:) = x; clear x

end
ypos(isnan(ypos))=0; 

% correct for certain bhv file issues
[brpath,BRdatafile,~] = fileparts(filename);





% check for BHV and NS6
bhv = concatBHV(bhvfile);
ns6file = [filename '.ns6'];


% extract visual stim info from BHV and ypos
Fs        = 30000; % always using NS6
refresh   =  ceil((1/bhv.ActualVideoRefreshRate) * Fs); % time for a screen refresh in sampels
yconv     = 0.5 + (ypos*bhv.PixelsPerDegree/bhv.ScreenYresolution); % accounts for CRT scan path


% determin trigger type if not specified as input
if isempty(trigger)
    if  any(any(strcmp(bhv.TaskObject,'gen(gReferenceDriftingGrating_di)')))
        trigger = 'drifting';
    elseif (strcmp(bhv.TaskObject{end-3},'gen(gGrating_di)') && strcmp(bhv.TaskObject{end-2}([1:3 7:13]),'sqr[0 0 0]') )
        trigger = 'custom';
    elseif strcmp(bhv.PhotoDiodePosition{1},'none')
        trigger = 'none';
        newTP   = []; 
        return
    else
        trigger = 'default';
    end
end



% constant re-triggering method
if any(strcmp({'constant'},trigger))
   
    % method specified as "constant"
    % assume constent offset relative to event code
    % good for when no photodiode signal is availiable for triggering
    
    newTP(:,1) = round(TP(:,1) + nr*refresh - refresh*yconv);
    newTP(:,2) = round(TP(:,2) + nr*refresh - refresh*yconv);
    return % stop exicuting here
    
end

        
% if not using constant mthod, look at BNC signal
ns_header  = openNSx(ns6file,'noread');
ns_labels  = cellfun(@(x) x(1:5),{ns_header.ElectrodesInfo.Label},'UniformOutput',0);
photoidx   = find(strcmp(ns_labels,photolabel)); 
if isempty(photoidx)
     newTP   = []; 
    trigger = sprintf('no channel "%s"',photolabel);
    return
end
channel    = sprintf('c:%u', photoidx);
    
win = [-3 3]*refresh;
tm  = win(1):win(2);
for t = 1:size(TP,1)
    
    for s = 1:size(TP,2)
        clear dat tp energy adj

        % individual timepoint (tp)
        tp = TP(t,s);
        
        % get photodiode signal around event
        timeperiod = sprintf('t:%u:%u', tp+win);
        NS = openNSx(ns6file,channel,timeperiod,...
            'read','precision','double','sample');
        
        
        dx = length( NS.Data) - diff(win);
        dat = NS.Data(dx:end); % typically a 103 sampel ofset when reading NS6 this way
        
        % transform signal to |zscore|
        dat = abs((dat - mean(dat)) / std(dat));

        %check magnitude and energy
        if ~any(dat > thresh)
           continue
        end
        energy(1)  = range(dat(tm<0));
        try
        energy(2)  = range(dat(tm>0));
        catch err
            err
        end
        
        % adjust TP accordingly
        if diff(energy) > 1
            % next peak is stimulus event
            clear tm2 dat2
            tm2  = tm(tm>0);
            dat2 = dat(tm>0);  
            adj  = min(tm2(dat2>thresh));
        else
            % stimulus event is assumed to be 1 refresh AFTER
            % the refresh imediatly preceding the event code 
            % (dev: bould could easily be 2)
             clear tm2 dat2
            tm2  = tm(tm<0);
            dat2 = dat(tm<0);
            adj = max(tm2(dat2>thresh)) + nr*refresh ;
        end
        
        if isempty(adj)
            newTP(t,s) = NaN;
            %disp('trigger fail')
        else
            newTP(t,s) = round((tp + adj) - refresh*yconv(t));
        end
        
    end
end


% plotting code used during development
%         if rem(t,25) == 0
%             clf
%             h = plot(tm,dat,'b'); hold on; 
%             plot([0 0],ylim,'k')
%             plot([adj adj],ylim,'r')
%             title(sprintf('%s\nt = %u s = %u',BRdatafile,t,s),'interpreter','none')
%         end
