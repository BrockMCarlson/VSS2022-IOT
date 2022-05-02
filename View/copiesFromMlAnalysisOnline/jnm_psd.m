function [jnmPxx, jnmPxxc, jnmf] = jnm_psd(varargin)


error(nargchk(1,7,nargin))
x = varargin{1};
[msg,nfft,Fs,window,noverlap,p,dflag]=jnm_psdchk(varargin(2:end),x);
error(msg)

% compute PSD
window = window(:);
n = length(x);		    % Number of data points
nwind = length(window); % length of window
if n < nwind            % zero-pad x if it has length less than the window length
    x(nwind)=0;  n=nwind;
end
% Make sure x is a column vector; do this AFTER the zero-padding 
% in case x is a scalar.
x = x(:);		

k = fix((n-noverlap)/(nwind-noverlap));	% Number of windows
                    					% (k = fix(n/nwind) for noverlap=0)

index = 1:nwind;
%KMU = k*norm(window)^2;	% Normalizing scale factor ==> asymptotically unbiased
 KMU = k*sum(window)^2;% alt. Nrmlzng scale factor ==> peaks are about right

Spec = zeros(nfft,1); % Spec2 = zeros(nfft,1);
for i=1:k
    if strcmp(dflag,'none')
        xw = window.*(x(index));
    elseif strcmp(dflag,'linear')
        xw = window.*detrend(x(index));
    else
        xw = window.*detrend(x(index),'constant');
    end
    index = index + (nwind - noverlap);
    Xx = abs(fft(xw,nfft)).^2;
    
    Spec = Spec + Xx;
%     Spec2 = Spec2 + abs(Xx).^2;
end

% Select first half
if ~any(any(imag(x)~=0)),   % if x is not complex
    if rem(nfft,2),    % nfft odd
        select = (1:(nfft+1)/2)';
    else
        select = (1:nfft/2+1)';
    end
    Spec = Spec(select);

else
    select = (1:nfft)';
end
freq_vector = (select - 1)*Fs/nfft;

% find confidence interval if needed
if (nargout == 3) || ((nargout == 0) && ~isempty(p)),
    if isempty(p),
        p = .95;    % default
    end

    confid = Spec * jnm_chi2conf(p,k)/KMU;

    if noverlap > 0
        disp('Warning: confidence intervals inaccurate for NOVERLAP > 0.')
    end
end

Spec = Spec*(1/KMU);   % normalize

% set up output parameters
if (nargout == 3),
   jnmPxx = Spec;
   jnmPxxc = confid;
   jnmf = freq_vector;
elseif (nargout == 2),
   jnmPxx = Spec;
   jnmPxxc = freq_vector;
elseif (nargout == 1),
   jnmPxx = Spec;
elseif (nargout == 0),
   if ~isempty(p),
       P = [Spec confid];
   else
       P = Spec;
   end
   newplot;
   plot(freq_vector,10*log10(abs(P))), grid on
   xlabel('Frequency'), ylabel('Power Spectrum Magnitude (dB)');
end
