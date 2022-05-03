BRdatafile    = 'E:\rig021_LaminarLabelingCollaboration\EndOfDayFileOutputs\220209_B\220209_B_evp003';

extension     = 'ns2'; % THIS CODE DOES NOT DOWNSAMPLE OR FILTER DATA
el            = 'eA';
sortdirection = 'ascending'; %  descending (NN) or ascending (Uprobe) % new note -- BMC 211007_B descenting and ascending is a moot point because of the new channel map
% pre           = 50;
% post          = 250;
pre           = 50;
post          = 250;
%chans         = [1:17 19:20 22:32];
chans    =    [1:32]; 
%chans           = [1:2:24];
trls          = [1:400];

 
flag_subtractbasline = true;
flag_halfwaverectify = false;
flag_normalize = false;
flag_interpolate = false;
interp_chans = [5,12,19];

clear LFP EventCodes EventTimes DAT TM CSD CSDf corticaldepth y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[LFP, EventCodes, EventTimes]= getLFP(BRdatafile,extension,el,sortdirection);
triggerpoints = EventTimes(EventCodes == 23 | EventCodes == 25 | EventCodes == 27 | EventCodes == 29| EventCodes == 31);
if isempty(chans)
    chans = [1:size(LFP,2)];
end
LFP = LFP(:,chans);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[DAT, TM] = trigData(LFP, triggerpoints , pre, post);
if isempty(trls)
    EVP = mean(DAT,3);
else
EVP = mean(DAT(:,:,trls),3);
end

if flag_normalize
    EVP = normalize(EVP,2);
end

if flag_interpolate 
    for i = 1:length(interp_chans)
        badChan = interp_chans(i);
        EVP(:,badChan) = (EVP(:,badChan+1) + EVP(:,badChan-1)) / 2;
    end
end

% deal w/ bad channes
switch BRdatafile
    case {'151208_E_rfori001' '151208_E_rfori002','151218_I_evp002'}
        EVP(:,17) = mean([EVP(:,18), EVP(:,16)],2);
    case '151205_E_dotmapping003'
        EVP(:,18) = mean([EVP(:,17), EVP(:,19)],2);
    case {'160115_E_evp001', '160115_E_rfori001', '160115_E_rfori002','160115_E_mcosinteroc001'}
        EVP(:,end-3:end) = [];
    case '160831_E_evp001'
        EVP(:,21) = mean([EVP(:,20), EVP(:,22)],2);
end
        
%%
%figure;
switch sortdirection
    case 'ascending' 
        corticaldepth = [chans] ;
    case 'descending'
        corticaldepth = fliplr([chans]);
end
%f_ShadedLinePlotbyDepth(EVP,corticaldepth,TM,[],1)
%title(BRdatafile,'interpreter','none')

%%
CSD = calcCSD(EVP);
if flag_subtractbasline
    CSD = bsxfun(@minus,CSD,mean(CSD(:,TM<0),2));
end
if flag_halfwaverectify
    CSD(CSD > 0) = 0;
end
CSD = padarray(CSD,[1 0],NaN,'replicate');
figure
subplot(1,2,1)
f_ShadedLinePlotbyDepth(CSD,corticaldepth,TM,[],1)
title(BRdatafile,'interpreter','none')
set(gcf,'Position',[1 40  700   785]); 
%%
CSDf = filterCSD(CSD);

subplot(1,2,2)
switch sortdirection
    case 'ascending'
        y = [chans];
        ydir = 'reverse';
    case 'descending'
        y = fliplr([chans]);
        ydir = 'normal';
end
imagesc(TM,y,CSDf); colormap(flipud(jet));
climit = max(abs(get(gca,'CLim'))*.8);
set(gca,'CLim',[-climit climit],'Ydir',ydir,'Box','off','TickDir','out')
hold on;
plot([0 0], ylim,'k')
c = colorbar;
caxis([-500 500])

