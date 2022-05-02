function CSD = calcCSD_classic(EVP)
% EVP is in (ms x chan) (i.e. 301 x 32)


totchan = size(EVP,2);

% electrode contact spacing in mm:
d = .1; % This is the electrode spacing

%padarray would also work here for simplicity.
EVPvak = padarray(EVP,[0 1],NaN,'replicate');
calcCSDonThis = permute(EVPvak,[2 1]); %dim chould be chan x ms
 
% Calculate CSD
%a -- chan above
%b -- f(x) voltage
%c -- chan below
for i = 2:totchan+1  %loop through channels of padded LFP (i.e 2-33)
    a = calcCSDonThis(i-1,:); %output is (ms x trial)
    b = calcCSDonThis(i,:); % This is your target channel
    c = calcCSDonThis(i+1,:);
    chOut = i-1;
     CSD(chOut,:) = (-1)*(a - 2*b + c)./(d^2);
end

%See page 3 schroeder et al (1998) for more detail.