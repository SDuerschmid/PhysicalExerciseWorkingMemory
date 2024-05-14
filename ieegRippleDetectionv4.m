function [ripplematrix,phig1,pind1,pwid1] = ...
          ieegRippleDetectionv4(LFP,time,srate,bandpass,cutoffstd)
      warning off
% IEEGRIPPLEDETECTION Analyses an EEG/MEG dataset for the occurence of 
%                     ripple events
%
% INPUT
%
% LFP          - 2D matrix (channel x (time x trials))
%
% time         - scalar array (1xn)
%
% srate        - scalar value
%
% bandpass     - bandwith for frequency filtering (1x2 scalar array)
%
% cutoffstd    - upper standard deviation limit of ripple events:
%                either empty (no upper limit)
%                or scalar value > 2.5 (lower limit)
%
% OUTPUT
%
% ripplematrix      - binary array (same size as input data) holding
%                     information about the occurence of ripples
%
% phig1,pind1,pwid1 - height, index and width of detected ripples
%
%
% Copyright 2022 Benedikt Auer, LIN Magdeburg
% v1 (updated 03/2023)
% v2 (updated 06/2023)
% v3 (updated 07/2023)
% v4 (updated 08/2023)
% v4.1 (updated 09/2023)

%% Initiate

ripplematrix = [];

%% Control for input

if nargin<5
    warning('The function expects 5 variables.')
    beep
    return
end
    
size_ch    = size(LFP,1);
size_exp   = size(LFP,2);
size_trial = length(time);

% LFP
if isempty(LFP) || all(all(LFP))==0
    warning('The input "data" is empty.')
    beep
    return
elseif size(LFP,3) > 1
    warning('The function expects "LFP" to be 2-dimensional (nxm).')
    beep
    return
end

% time
if isempty(time) || ~ismatrix(time)
    warning('The function expects "time" to be a scalar array (1xn).')
    beep
    return
end

% srate
if isempty(srate) || ~ismatrix(srate) || (~all(size(srate)==[1,1]) && ~isnumeric(srate))
    disp('The function expects "srate" to be a scalar value.')
    beep
    return
end

% bandpass
if ~all(size(bandpass)==[1 2]) && ~isnumeric(bandpass)
    warning('The function expects "bandpass" to be a 1x2 scalar array (e.g. [80 150]).')
    beep
    return
end

% flag9std
if ~isempty(cutoffstd)
    if ~isscalar(cutoffstd) || ~cutoffstd > 0
        warning(['The function expects "cutoffstd" to be a scalar value'...
                 ' greater than 2.5 (e.g. 9) or be empty.'])
        beep
        return
    end
end

%% Initiation

samplingfactor = srate/1000; % normalised to ms

%% Ripple Detection (at bandwidth)

disp('.. ripple detection')

% Indentification of peaks (> 2.5*SD, minimal length of 38ms, maximal
% lenght of 500ms, at least 3 cycles per 2s window centered on most 
% prominent peak, most prominent peak must be 20% more dominant than
% following ones)

% initiate

ripplematrix = false(size_ch,size_exp);

phig1     = cell(1,size_ch);
pind1     = cell(3,size_ch);
pwid1     = cell(1,size_ch);

pvalid    = cell(1,size_ch);
timevec   = zeros(1,5);

for c = 1:size_ch
    
    tic
    
    % Bandpassfiltering between bandwidth frequencies

    LFPbandpassCH = ab_BandpassFilter(double(LFP(c,:)),srate,bandpass);
    
    % Hilbert Tranformation at bandwidth frequencies to identify ripple
    % events. To save memory (as the Hilbert-transformed data is only
    % needed within this for-loop), the transformation is applied to every
    % channel individually.
    LFPhilbertCH  = ab_BandpassFilterAmplitude(double(LFP(c,:)),srate,bandpass);
    
    % As the original MEG trials were put together into one long
    % experiment, filter-artefacts are going to be generated at the borders
    % between the trials. Therefore, 100ms at the beginning and end of the
    % original trials are going to be set to 0 in the Hilbert-transform.
    
    trialcutout = zeros(1,size_trial);
    trialcutout([1:(100*srate/1000),end-(100*srate/1000):end]) = 1;
    LFPhilbertCH(repmat(trialcutout,1,size_exp/size_trial)==1) = 0;
    
    % Events (identified by 2.5x standard deviation and window size between
    % e.g. 38 (3 x 80Hz) and 500ms (40 x 80Hz). MinPeakWidth is only half 
    % of the peak width, which is why the window size is divided by 2. 
    % The samplingfactor makes sure 1 data point is equivalent to 1ms.
    
    threshhb = mean(LFPhilbertCH)+2.5*std(LFPhilbertCH);
    
    [phig1{1,c},pind1{1,c},pwid1{1,c},~] = ...
            findpeaks(LFPhilbertCH,'MinPeakHeight',threshhb,...
                      'MinPeakProminence',threshhb,...
                      'MinPeakWidth',(round(1000/bandpass(1)*3)/2)*samplingfactor,...
                      'MaxPeakWidth',(round(1000/bandpass(1)*40)/2)*samplingfactor,...
                      'MinPeakDistance',(round(1000/bandpass(1)*3))*samplingfactor,...
                      'Annotate','extents','WidthReference','halfheight');
                                                  
    % Remove Events with Peaks > nx standard deviation
    
    if ~isempty(cutoffstd)
        todel = find(phig1{1,c} > (mean(LFPhilbertCH) + cutoffstd*std(LFPhilbertCH)));
        pind1{1,c}(todel) = [];
        phig1{1,c}(todel) = [];
        pwid1{1,c}(todel) = [];
    end
    
    % Event-wise Processing (Width correction, Prominence Check,...)
    
    threshbp = mean(LFPbandpassCH) + 2.5*std(LFPbandpassCH);
    
    pvalid{1,c} = zeros(1,length(pind1{1,c}));
    
    for d = 1:length(pind1{1,c})
        
        % Initiate peak limits
        
        tempind = pind1{1,c}(d); % peak
        templ   = round(tempind - pwid1{1,c}(d)/2);
        templl  = round(tempind - 2*pwid1{1,c}(d)/2);
        tempr   = round(tempind + pwid1{1,c}(d)/2);
        temprr  = round(tempind + 2*pwid1{1,c}(d)/2);
        
        % Handle peak limits at the start and end of the data series
        
        if templ<1
            templ = 1;
        end
        if templl<1
            templl = 1;
        end
        if tempr>length(LFPhilbertCH)
            tempr = length(LFPhilbertCH);
        end
        if temprr>length(LFPhilbertCH)
            temprr = length(LFPhilbertCH);
        end
        
        % Identify left and right limit of ripple event by looking between
        % halfwidth & 2*halfwidth and detecting the point of changing
        % curvature (where the next peak begins)
        
        y1 = LFPhilbertCH(templ);
        y2 = LFPhilbertCH(tempr);
        
        for x1 = templ:-1:templl % leftward limit
            if LFPhilbertCH(x1)>y1
                break
            else
                y1 = LFPhilbertCH(x1);
            end
        end
        for x2 = tempr:1:temprr % rightward limit
            if LFPhilbertCH(x2)>y2
                break
            else
                y2 = LFPhilbertCH(x2);
            end
        end
        
        % one step back/forth to point of changing sign
        
        pind1{2,c}(d) = x1+1;
        pind1{3,c}(d) = x2-1;
        
        % Identify number of ripples within the event
        
        [phigtemp,pindtemp,~,~] = ...
            findpeaks(LFPbandpassCH(pind1{2,c}(d):pind1{3,c}(d)),...
                      'MinPeakHeight',threshbp);
      
        % If there is at least 3 ripples, check for presence of a prominent
        % peak
        
        if length(pindtemp) >= 3
                        
            [~,tempind] = max(phigtemp);
            
            if phigtemp(tempind) > threshbp % mean+2.5*std restriction
            
                if tempind==1
                    if phigtemp(2)<0.8*phigtemp(1)
                        pvalid{1,c}(d) = 1;
                    end
                elseif tempind==length(phigtemp)
                    if phigtemp(end-1)<0.8*phigtemp(end)
                        pvalid{1,c}(d) = 1;
                    end
                else
                    if phigtemp(tempind-1)<0.8*phigtemp(tempind) && ...
                       phigtemp(tempind+1)<0.8*phigtemp(tempind)
                        pvalid{1,c}(d) = 1;
                    end  
                end 
            end
        end
        
        %%% entry in binary matrix
        
        if pvalid{1,c}(d) == 1
            ripind = pind1{2,c}(d) + pindtemp(tempind) - 1;
            ripplematrix(c,ripind) = 1;
        end
    end
    
    % Sort out events with less than 3 peaks and without a prominent peak
    
    if ~isempty(phig1{1,c})
        todel = find(pvalid{1,c}==0);
        pind1{1,c}(todel) = [];
        pind1{2,c}(todel) = [];
        pind1{3,c}(todel) = [];
        phig1{1,c}(todel) = [];
        pwid1{1,c}(todel) = [];
    end
    
    if c<5
        timevec(c) = toc;
    elseif c==5
        timevec(c) = toc;
        temp = datestr(datetime + (size_ch-5)*seconds(mean(timevec)));
        disp(['..about to finish at: ' temp(end-8:end)])
    end
    
end

%% Visual inspection

% figure()
% for a = 1:length(phig1{c})
%     xrange = pind1{2,c}(a):pind1{3,c}(a);
% %     peakbp = pindtemp{c}(ismember(pindtemp{c},pind1{2,c}(a):pind1{3,c}(a)));
%     plot(xrange,LFPhilbertCH(xrange));
%     hold on
%     plot(xrange,LFPbandpassCH(xrange));
%     plot(pind1{1,c}(a),LFPhilbertCH(pind1{1,c}(a)),'bo')
% %     plot(peakbp,LFPbandpassCH(peakbp),'ro')
% %     plot([xrange(1) xrange(end)],threshhb*ones(1,2),'b:')
% %     plot([xrange(1) xrange(end)],threshbp*ones(1,2),'r:')
%     hold off
%     pause(1)
%     drawnow
% end

disp('.. ripple detection done')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


warning on