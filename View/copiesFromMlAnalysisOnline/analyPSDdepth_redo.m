%jnm_pdr.m
%Jake Westerberg
%Vanderbilt University
%August 19, 2016
%v1.0.0
%   Detailed explanation goes here
tic

clear
BRdatafile    = 'D:\rig021_LaminarLabelingCollaboration\EndOfDayFileOutputs\220131_B\220131_B_evp004';

%chanLim = [10:13 15:17 19:25]; 
% chanLim = [1:6 8:14 16:32]; 
%chanLim = [1:14 16:32]; 
chanLim = [1:24];
jnmfile = [BRdatafile '.ns2'];
badchan = [];
flag_interpolate = true;
interp_chans = [5];

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

%if flag_interpolate 
    %for i = 1:length(interp_chans)
     %   badChan = interp_chans(i);
   % lfp2(interp_chan1,:) = (lfp2(interp_chan1+1,:) + lfp2(interp_chan1-1,:)) / 2;
    %end
    %if ~isempty(interp_chan2)
    %lfp2(interp_chan2,:) = (lfp2(interp_chan2+1,:) + lfp2(interp_chan2-1,:)) / 2;
    %end
    %if ~isempty(interp_chan3)
   % lfp2(interp_chan3,:) = (lfp2(interp_chan3+1,:) + lfp2(interp_chan3-1,:)) / 2;
   % end
%end
valn = 2^val;

pdrplot = figure( 'Position', [ 0 0 750 750 ] );
    
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
    
    image( jnmf(1,1:52), 1:size(jnm2,1), jnm2 );
    colormap('hot');
    %set(gca,  'XTickLabel', [] );
    %xticklabels(1:1:52)
    
    
end

toc
[~,fname] = fileparts(BRdatafile);
title(fname,'interpreter','none')

%frequency axis is jnmf(77) = 148Hz




jnmrm = jnm;
jnmrm(badchan,:) = NaN;

normpowAB = jnmrm(:,:) ./ nanmax(jnmrm(:,:), [], 1);

figure; imagesc(normpowAB(:,1:100))


colormap('Jet')

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
xlim([1 100])





