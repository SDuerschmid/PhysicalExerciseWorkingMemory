function [ripplematrix] = ieegRippleDetection(input,bandpass,cutoffstd)
% IEEGRIPPLEDETECTION Analyses an EEG/MEG dataset for the occurence of 
%                     ripple events
%
% INPUT
%
% input         - structure with following fields: 
%                'data'  : 3D matrix (channel x time x trials)
%                'time'  : scalar array (1xn)
%                'srate' : scalar value
%
% bandpass      - bandwith for frequency filtering (1x2 scalar array)
%
% cutoffstd     - upper standard deviation limit of ripple events:
%                 either empty (no upper limit)
%                 or scalar value > 2.5 (lower limit)
%
% OUTPUT
%
% ripplematrix  - binary array (same size as input data) holding
%                 information about the occurence of ripples
%
%
% Copyright 2022 Benedikt Auer, LIN Magdeburg

%% Initiate

ripplematrix = [];

%% Control for input

if nargin<3
    warning('The function expects 3 variables.')
    beep
    return
end

% input structure
if ~isstruct(input)
    warning('The function expects a structure as input variable.')
    beep
    return
end
if ~isfield(input,'data') || ~isfield(input,'time') || ~isfield(input,'srate')
    warning(['The function expects a structure with the fields "data", '...
             '"time" and "srate".'])
    beep
    return
else
    LFP   = input.data(:,:);
    srate = input.srate;
    time  = input.time;
    
    size_ch    = size(LFP,1);
    size_exp  = size(LFP,2);
    size_trial = length(time);
    
    clear input
end

% data
if isempty(LFP) || all(all(all(LFP)))==0
    warning('The input "data" is empty.')
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

% Bandpassfiltering between bandwidth frequencies

LFPbandpass = ab_BandpassFilter(double(LFP),srate,bandpass);

% Indentification of peaks (> 2.5*SD, minimal length of 38ms, maximal
% lenght of 500ms, at least 3 cycles per 2s window centered on most 
% prominent peak, most prominent peak must be 20% more dominant than
% following ones)

phig1    = cell(1,size_ch);
pind1    = cell(3,size_ch);
pwid1    = cell(1,size_ch);
phig2    = cell(1,size_ch);
pind2    = cell(1,size_ch);
pdom2    = cell(1,size_ch);

pindrip  = cell(1,size_ch);
pvalid   = cell(1,size_ch);

for c = 1:size_ch
    waitingasterisks( c,size_ch )
    LFPbandpassCH = LFPbandpass(c,:);
    
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
    trialcutout([1:(100*srate/1000),end-(100*srate/1000):end])  = 1;
    LFPhilbertCH(repmat(trialcutout,1,size_exp/size_trial)==1) = 0;
    
    % Events (identified by 2.5x standard deviation and window size between
    % 38 (3 x 80Hz) and 500ms. MinPeakWidth is only half of the peak width,
    % which is why the window size is divided by 2. The samplingfactor
    % makes sure 1 data point is equivalent to 1ms.
    
    [phig1{1,c},pind1{1,c},pwid1{1,c},~] = ...
        findpeaks(LFPhilbertCH,'MinPeakHeight',mean(LFPhilbertCH)+2.5*std(LFPhilbertCH),...
                        'MinPeakProminence',mean(LFPhilbertCH)+2.5*std(LFPhilbertCH),...
                        'MinPeakWidth',(38/2)*samplingfactor,...
                        'MaxPeakWidth',(500/2)*samplingfactor,...
                        'Annotate','extents','WidthReference','halfprom');
                    
	% Ripples within Events (identified by 2.5x standard deviation)
    
	[phig2{1,c},pind2{c},~,pdom2{c}] = findpeaks(LFPbandpassCH,'MinPeakHeight',...
                                       mean(LFPbandpassCH)+2.5*std(LFPbandpassCH));
                                   
    % Remove Events with Peaks > 9x standard deviation
    
    if ~isempty(cutoffstd)
        todel = find(phig1{1,c} > (mean(LFPhilbertCH) + cutoffstd*std(LFPhilbertCH)));
        pind1{1,c}(todel) = [];
        phig1{1,c}(todel) = [];
        pwid1{1,c}(todel) = [];
    end
    
    % Event-wise Processing (Width correction, Prominence Check,...)
                                    
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
        
        pindrip{c}{d} = pind2{c}(pind2{c}>pind1{2,c}(d)&pind2{c}<pind1{3,c}(d));
        
        % If there is at least 3 ripples, check for presence of a prominent
        % peak
        
        if length(pindrip{c}{d})>=3
            
            tempdom = pdom2{c}(ismember(pind2{c},pindrip{c}{d}));
            
            [~,tempind] = max(tempdom);
            
            if tempind==1
                if tempdom(2)<0.8*tempdom(1)
                    pvalid{c}(d) = 1;
                else
                    pvalid{c}(d) = 0;
                end
            elseif tempind==length(tempdom)
                if tempdom(end-1)<0.8*tempdom(end)
                    pvalid{c}(d) = 1;
                else
                    pvalid{c}(d) = 0;
                end
            else
                if tempdom(tempind-1)<0.8*tempdom(tempind) && ...
                   tempdom(tempind+1)<0.8*tempdom(tempind)
                    pvalid{c}(d) = 1;
                else
                    pvalid{c}(d) = 0;
                end  
            end 
        end
    end
    
    % Sort out events with less than 3 peaks and without a prominent peak
    
    if ~isempty(phig1{1,c})
        phig1{1,c}(pvalid{c}==0)   = [];
        pind1{1,c}(pvalid{c}==0)   = [];
        pind1{2,c}(pvalid{c}==0)   = [];
        pind1{3,c}(pvalid{c}==0)   = [];
    end
    
end

clear pvalid pindrip pwid1 pdom2 templ templl tempr temprr tempind tempdom...
      x1 x2 y1 y2 todel LFPhilbertCH LFPbandpassCH

%% Fused Ripple event correction

% Binary Ripple Matrix (whole duration of ripple event)

ipivec = cell(1,size_ch);
irivec = cell(1,size_ch);
irimatrixwhole = false(size_ch,size_exp);

for c = 1:size_ch
    
    for d = 1:length(pind1{1,c})
        irimatrixwhole(c,pind1{2,c}(d):pind1{3,c}(d)) = true;
    end

    tempmatrix = bwlabel(irimatrixwhole(c,:));

    for d = 1:max(tempmatrix)

        tempindleft  = find(tempmatrix==d,1);
        tempindright = find(tempmatrix==d,1,'last');
        tempindrange = tempindleft:tempindright;
        
        % Correction of fused Ripple peaks (pind1), only keep highest one
        
        temprippelind = pind1{1,c}(ismember(pind1{1,c},tempindrange));
        temprippelhig = phig1{1,c}(ismember(pind1{1,c},tempindrange));
        
        if numel(temprippelind)>1
            [~,maxind] = max(temprippelhig);
            pind1{2,c}(ismember(pind1{1,c},temprippelind(maxind))) = tempindleft;
            pind1{3,c}(ismember(pind1{1,c},temprippelind(maxind))) = tempindright;
            
            temprippelind(maxind) = [];
            pind1{3,c}(ismember(pind1{1,c},temprippelind)) = [];
            pind1{2,c}(ismember(pind1{1,c},temprippelind)) = [];
            pind1{1,c}(ismember(pind1{1,c},temprippelind)) = [];
        end
        
        % inter peak intervals (only within events)
        
        ipivec{c}{d} = diff(pind2{c}(ismember(pind2{c},tempindrange)));
        
    end 
    
    % inter ripple event intervals
    
    irivec{c} = diff(pind1{1,c});
    
end

clear tempmatrix tempindleft tempindright tempindrange temprippelind temprippelhig

% Correction of peak indices (keep only the ones within valid ripple
% events)

for c = 1:size_ch
    
    phig2{c}(~ismember(pind2{c},find(irimatrixwhole(c,:)==1))) = [];
    pind2{c}(~ismember(pind2{c},find(irimatrixwhole(c,:)==1))) = [];
    
end

clear irimatrixwhole

%% Create Binary Ripple Matrix (only apex of ripple event)

% initiate 
ripplematrix = false(size_ch,size_exp);

% go

for c = 1:size_ch
    
    for d = 1:length(pind1{1,c})
        
        % Find dominant peak (negative or positive peak)
        
        tempindrange = pind1{2,c}(d):pind1{3,c}(d);
        
        [~,tempindpeak] = max(abs(LFPbandpass(c,tempindrange)));
        
        tempind   = tempindrange(tempindpeak);
        
        % entry in binary ripple-peak matrix
        
        ripplematrix(c,tempind) = 1;
    end
end

clear tempind tempindrange tempindpeak

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End of function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end