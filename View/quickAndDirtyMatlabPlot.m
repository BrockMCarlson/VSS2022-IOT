% plot IDX.SDF_avg
function quickAndDirtyMatlabPlot(IDX)
conditions = IDX.conditions;
SDF_avg = IDX.SDF_avg;
exUnit = 15;

%smoothData
clear SDF_smoothed
for sd = 1:8
    SDF_smoothed{sd,1} = smoothdata(IDX.SDF_avg{sd},2);
end


% Create a more usable table
% If the inputs are workspace variables, then table assigns their names as 
% the variable names in the output table.

%Variable to put into this table
monocular_PO_LE     =  SDF_smoothed{1,1}; 
IOT_PO_LE           =  SDF_smoothed{2,1};  
monocular_PO_RE     =  SDF_smoothed{3,1}; 
IOT_PO_RE           =  SDF_smoothed{4,1}; 
monocular_NPO_LE    =  SDF_smoothed{5,1}; 
IOT_NPO_LE          =  SDF_smoothed{6,1}; 
monocular_NPO_RE    =  SDF_smoothed{7,1}; 
IOT_NPO_RE          =  SDF_smoothed{8,1}; 

sorted = table(monocular_PO_LE,...
    IOT_PO_LE,...  
monocular_PO_RE,...
IOT_PO_RE,...
monocular_NPO_LE,...
IOT_NPO_LE,...
monocular_NPO_RE,...
IOT_NPO_RE);

for i = 1:32 % contacts
    figure
    sgtitle(strcat('IDX Plot Chan Number__',string(i)))

    subplot(2,2,1) % PO RE
    plot(IDX.sdftmCrop,sorted{i,3}); hold on
    plot(IDX.sdftmCrop,sorted{i,4})
    xlim([-.15 .8])
    ylim([-5 40])
    title('PO RE')

    subplot(2,2,2) % PO LE
    plot(IDX.sdftmCrop,sorted{i,1}); hold on
    plot(IDX.sdftmCrop,sorted{i,2})
    xlim([-.15 .8])
    ylim([-5 40])
    title('PO LE')

    subplot(2,2,3) % NPO RE    
    plot(IDX.sdftmCrop,sorted{i,7}); hold on
    plot(IDX.sdftmCrop,sorted{i,8})
    xlim([-.15 .8])
    ylim([-5 40])
    title('NPO RLE')

    subplot(2,2,4) % NPO LE
    plot(IDX.sdftmCrop,sorted{i,5}); hold on
    plot(IDX.sdftmCrop,sorted{i,6})
    xlim([-.15 .8])
    ylim([-5 40])
    title('NPO LE')

end

clear i
figure
tiledlayout('flow')
for i = 6:29 % contacts
   nexttile
%     sgtitle('PO RE')
%     subplot(22,2,i) % PO RE
    plot(IDX.sdftmCrop,sorted{i,3}); hold on
    plot(IDX.sdftmCrop,sorted{i,4})
    xlim([-.15 .8])
    ylim([-5 40])
    title(strcat('Chan Number',string(i)))
   
end

end
