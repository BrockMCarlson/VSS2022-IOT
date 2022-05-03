function f_ShadedLinePlotbyDepth(ASAbyDepth,corticaldepth,tm,N,offset,useblack)

if nargin < 6
    useblack = false;
end

if size(ASAbyDepth,1) > size(ASAbyDepth,2)
    ASAbyDepth = ASAbyDepth';
end


%    scale means to values between 1 and -1 with basline at 0
baslined_ASA =  bsxfun(@minus,ASAbyDepth, mean(ASAbyDepth(:,tm<0),2));
scalingfactor = max(max(abs(baslined_ASA),[],2)); scalingrange = [-1 1];
scaled_ASA   =  baslined_ASA .* 1/scalingfactor;



% plot!
for depth = 1:size(ASAbyDepth,1)
    
    x  = tm;
    bl = -offset*depth ;
    y  = scaled_ASA(depth,:) + bl;
    
    % basline
    baseline = repmat(bl,1,length(x));
    plot(x,baseline,'k')
    
    % fill positive and negative curves
    sink = y;
    sink(sink>baseline) = bl;
    source = y;
    source(source<baseline) = bl;
    if useblack
        mmfill(x,baseline,source,[.6 .6 .6]), hold on
        mmfill(x,baseline,sink,[0 0 0]),hold on
    else
        mmfill(x,baseline,source,[.6 .6 .6]), hold on
        mmfill(x,baseline,sink,[.6 .6 .6]),hold on
    end
    
    % timecourse
    plot(x,y,'b','LineWidth',1); hold on;
    
    
    % label depth and n
    if ~isempty(corticaldepth)
        if rem(corticaldepth(depth),mode(abs(diff(corticaldepth)))*5) == 0;
            text(min(x),bl,num2str(corticaldepth(depth)),'HorizontalAlignment','right','FontName', 'Arial','FontSize', 12);
        end
    end
    if ~isempty(N)
        text(max(x),bl,num2str(N(depth)),'HorizontalAlignment','left','FontName', 'Arial','FontSize', 12); hold on;
    end
    
    
    
    

end

%    add scale bar and label
        ystr = sprintf('Scale Bar = %.2f %s\n', scalingfactor/2*offset);
    

% make pretty
xlim([min(tm) max(tm)]);
ylim([-1*offset*size(ASAbyDepth,1) -1*offset] + [-1*offset offset]);
plot([0 0], ylim,'k');
set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.02 .02] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'off'      , ...
    'YGrid'       , 'off'      , ...
    'XColor'      , [0 0 0], ...
    'YColor'      , [0 0 0], ...
    'YTick'       , [], ...
    'LineWidth'   , 1         );

% axies labels and title
hYLabel = ylabel(ystr);
set( hYLabel                ,...
    'FontName'   , 'Arial' ,...
    'FontSize'   , 12           );
hXLabel= xlabel('Time');
    set( hXLabel                ,...
        'FontName'   , 'Arial' ,...
        'FontSize'   , 12      );
end

