function [F,cf] = GetExponentialCenterFrequency( freqrange,Nfreq,width )


%% center frequencies
cf          = round( exp( linspace( log( freqrange( 1 )),log( freqrange( 2 )),Nfreq )))';

%% looking for double cfs if Nfreq is too high
if min( diff( cf ))==0
    k = find( diff( cf )==0 );
    fprintf(['\n number of frequencies reduced to ' num2str( Nfreq-length( k )) ' \n'])
    cf( k+1 ) = [];
end

%% frequency bands
F           = [cf-cf*width cf+cf*width];