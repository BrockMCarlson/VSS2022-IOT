function [DAT, TM] = trigData(continuousdata, triggerpoints , pre, post)


% very simple d demesntion
% trigger points, pre, and post should all be in samples
% output is SAMPLES x CHANNELS x TRIALS
% MAC
% July 2014

% check input
[m,n] = size(continuousdata);
if n > m
    error('continuous data should be samples along the first dim and channels along the second dim')
end

% get dimn, preallocate
maxchan = size(continuousdata, 2);
maxtr   = length(triggerpoints);
DAT     = NaN(post + pre + 1, maxchan,maxtr);
TM      = (0:size(DAT,1)-1) - pre;


for ch = 1:maxchan
    for tr = 1:maxtr
        tp = triggerpoints(tr);
        tp = round(tp);
        DAT(:,ch,tr) = continuousdata(tp-pre:tp+post,ch);
    end
end



