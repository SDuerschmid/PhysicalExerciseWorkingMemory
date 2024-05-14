function datafilt = ab_BandpassFilter(data,srate,freq)
% AB_BANDPASSFILTER   Performes Bandpass Filtering on 1- or 2-dimensional
%                     data array with given sampling rate between upper and
%                     lower frequency band
%
% INPUT
%
% data     - input data (channels x timepoints)
%
% srate    - sampling frequency in Hz (scalar)
%
% freq     - bandpass frequency band (1x2 array)
%
% OUTPUT
%
% datafilt - bandpass-filtered data
%
%
% Copyright 2021 Benedikt Auer, LIN Magdeburg

%% Variante FFT

% t1 = fft(data(1,:));
% l1 = length(data(1,:));
% t4 = srate * (0:(l1))/l1;
% t4 = t4(1:end-1);
% plot(t4,t1);
% xlabel('Frequency (Hz)')
% ylabel('Abundance')
% title('FFT-Band of data before filtering')
% 
% t1(t4<freq(1)) = 0;
% t1(t4>freq(2)) = 0;
% 
% plot(t4,t1);
% xlabel('Frequency (Hz)')
% ylabel('Abundance')
% title('FFT-Band of data after filtering')
% 
% datafilt = ifft(t3);
% plot(1:length(datafilt),datafilt,'-','LineWidth',1.8);
% set(gca,'Color',[.1 .1 .1])

%% Variante Filer

[szx,szy,szz] = size(data);
datafilt      = zeros(szx,szy,szz,size(freq,1));

for f = 1:size(freq,1)
    X                       = reshape(permute(data,[1 3 2]),[szz*szx szy]);
    [a,b]                   = butter(2,[freq(f,1)/(srate/2),freq(f,2)/(srate/2)]);
    ffX                     = permute(filtfilt( a,b,permute(X,[2 1])),[2 1]);
%     ffX                     = permute(filter(a,b,permute( X,[2 1])),[2 1]);
    datafilt( :,:,:,f )      = permute(reshape(ffX,[szx szz szy]),[1 3 2]);
end

end