function plotCSDandPSDfromNEV(holderName,holderUseChans,holderInterpChans)
%%

BRdatafile = holderName;

extension     = 'ns2'; % THIS CODE DOES NOT DOWNSAMPLE OR FILTER DATA
el            = 'eD';
sortdirection = 'ascending'; %  descending (NN) or ascending (Uprobe) % new note -- BMC 211007_B descenting and ascending is a moot point because of the new channel map
pre           = 50;
post          = 250;
chans = holderUseChans;

 
flag_subtractbasline = true;
flag_halfwaverectify = false;
flag_interpolate = true;
interp_chans = holderInterpChans;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[LFP, EventCodes, EventTimes]= getLFP(BRdatafile,extension,el,sortdirection);
triggerpoints = EventTimes(EventCodes == 23 | EventCodes == 25 | EventCodes == 27 | EventCodes == 29| EventCodes == 31);
if isempty(chans)
    chans = [1:size(LFP,2)];
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[DAT, TM] = trigData(LFP, triggerpoints , pre, post);
DAT = DAT(:,chans,:);
EVP = mean(DAT,3);


if flag_interpolate 
    for i = 1:length(interp_chans)
        badChan = interp_chans(i);
        EVP(:,badChan) = (EVP(:,badChan+1) + EVP(:,badChan-1)) / 2;
    end
end

      
switch sortdirection
    case 'ascending' 
        corticaldepth = chans ;
    case 'descending'
        corticaldepth = fliplr(chans);
end


%%
CSD = calcCSD_classic(EVP); % contains padArray. Input is time x chan. Output is Chan x time
if flag_subtractbasline
    CSD = bsxfun(@minus,CSD,mean(CSD(:,TM<0),2));
end
if flag_halfwaverectify
    CSD(CSD > 0) = 0;
end
figure
subplot(1,6,1)
f_ShadedLinePlotbyDepth(EVP,corticaldepth,TM,[],1)
sgtitle(BRdatafile,'interpreter','none')
%%

subplot(1,6,2)
switch sortdirection
    case 'ascending'
        y = [chans];
        ydir = 'reverse';
    case 'descending'
        y = fliplr([chans]);
        ydir = 'normal';
end
imagesc(TM,y,CSD); colormap(flipud(jet));
climit = max(abs(get(gca,'CLim'))*.6);
set(gca,'CLim',[-climit climit],'Ydir',ydir,'Box','off','TickDir','out')
hold on;
plot([0 0], ylim,'k')
c = colorbar;
% caxis([-500 500])

subplot(1,6,3)
CSDf = filterCSD(CSD);
imagesc(TM,y,CSDf); colormap(flipud(jet));
climit = max(abs(get(gca,'CLim'))*.6);
set(gca,'CLim',[-climit climit],'Ydir',ydir,'Box','off','TickDir','out')
hold on;
plot([0 0], ylim,'k')
c = colorbar;
% caxis([-500 500])


%% PSD code

%%
%%


chanLim = chans;
jnmfile = [BRdatafile '.ns2'];
badchan = [];

if ~exist( 'val', 'var' )    
    val = 15; 
end

t = openNSx( jnmfile, 'noread' );

tn = ~strcmp( 'E', { t.ElectrodesInfo.ConnectorBank } );
nsx.E = length( tn );
nsx.neural = sum( tn );
nsx.anlg = sum( ~tn );

if exist('electrode')
error('what goes here?')   
end

neuralChan = find( tn );
bncChan = find( ~tn );

nsx.neuralL = { t.ElectrodesInfo( tn ).Label };
nsx.neuralI = t.ElectrodesInfo( tn );

nsx.bncL = { t.ElectrodesInfo( ~tn ).Label };
nsx.bncI = t.ElectrodesInfo( ~tn );

nsx.rnge = ...
    ( ( length( t.ElectrodesInfo( 1 ).MinAnalogValue : ...
    t.ElectrodesInfo( 1 ).MaxAnalogValue ) ) ./ ...
    ( length( t.ElectrodesInfo( 1 ).MinDigiValue : ...
    t.ElectrodesInfo( 1 ).MaxDigiValue ) ) );

nsx.fs = t.MetaTags.SamplingFreq;
nsx.nyq = nsx.fs / 2;
nsx.deci = nsx.fs / 1000;

electD = openNSx( jnmfile, 'c:1', 'read' );
tData = double( electD.Data );

samples = length( tData );

bnc = zeros( nsx.anlg, ceil( samples / nsx.deci )  );
lfp = zeros( nsx.neural, ceil( samples / nsx.deci ) );
    
electD = openNSx( jnmfile );

tData = ( double( electD.Data ) ).' ;
t2Data = tData( :, bncChan );
tData = tData( :, neuralChan );

electD.Data = [];

tData = tData ./ 4;

lfp = tData.';
bnc = t2Data.';

clear tData t2Data electD 

if size( lfp, 1 ) < 33
    
    pNum = 1;
    
else
    
    pNum = 2;
    
end


if pNum == 2
    pChan(1) = 24;
    idx(1,:) = [1 24];
    pChan(2) = 32;
    idx(2,:) = [25 56];
else
    
pChan = size( lfp, 1 ) / pNum;
idx(1,:) = [1 pChan];
end


    

for k = 1 : pNum
    
lfp2 = jnm_reorder( lfp(idx(k,1):idx(k,2),:), nsx.neuralL(idx(k,1):idx(k,2)), 'BR', pNum, pChan(k) );

if flag_interpolate 
    for i = 1:length(interp_chans)
        badChan = interp_chans(i);
        lfp2(badChan,:) = (lfp2(badChan+1,:) + lfp2(badChan-1,:)) / 2;
    end
end


valn = 2^val;

    jnm = zeros( numel(chanLim), 257 );
    ictr = 1;
    for i = chanLim
        [ jnm( ictr, : ),~,jnmf(ictr,:) ] = jnm_psd( lfp2( i, end - valn : end ), ...
            512, 1000, 512, 0);
        ictr = ictr+1;
    end
    
    jnm2 = zeros( numel(chanLim), 52 );
    
    for i = 1 : 52
        
        jctr = 1;
        for j = chanLim
            
            jnm2( jctr, i ) = ( jnm( jctr, i ) - mean( jnm( :, i ) ) ) ...
                / mean( jnm( :, i ) ) * 100;
            jctr =jctr+1;
        end
    end
    
    %jnm2(:,31:33) = 0; %Manually remove 60Hz signal
    
    
end


[~,fname] = fileparts(BRdatafile);
title(fname,'interpreter','none')

%frequency axis is jnmf(77) = 148Hz




jnmrm = jnm;
jnmrm(badchan,:) = NaN;

normpowAB = jnmrm(:,:) ./ nanmax(jnmrm(:,:), [], 1);

%Apply spatial filter to PSD
PSDf = filterCSD(normpowAB);

% Plot PSD
subplot(1,6,[4 5]);
imagesc(PSDf(:,1:100))

psdAx = gca;
colormap(psdAx,'Jet')

xlabel ={};
indx = 1;
for f = 1:5:100
    tmp = jnmf(1,f);
    tmp = round(tmp);
    xlabel{indx} = num2str(tmp);
    indx=indx+1;
end

set(gca, 'xtick', 1:5:100);
set(gca, 'xticklabel', xlabel)
d = colorbar;
set(gcf,'Position',[5.8000 98.6000 1.5072e+03 671.2000]); 

xlim([1 100])

%% Gamma beta cross
freq_vector = jnmf(1,:);
theta_index = (freq_vector < 10) ;
beta_index = (freq_vector > 10) & (freq_vector < 35);
gamma_index = (freq_vector > 38) ;

clear i avgTheta avgBeta avgGamma
for i = 1:size(normpowAB,1)
    avgTheta(i,1) = mean(normpowAB(i,theta_index));
    avgBeta(i,1) = mean(normpowAB(i,beta_index));
    avgGamma(i,1) = mean(normpowAB(i,gamma_index));
end

subplot(1,6,6)
plot(avgTheta)
hold on
plot(avgBeta)
hold on
plot(fliplr(avgGamma))
view([90 -90])
set(gca,'xdir','reverse')
legend('Theta','Beta','Gamma','Location','northeast')
titleText = {'Normalized Gamma x Beta power across contacts',BRdatafile(22:end)};



end