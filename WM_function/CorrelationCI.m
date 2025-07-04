function [ci,d] = CorrelationCI( x,y )

%% permutation
Nruns = 10e3;
linFit = zeros( Nruns,length( x ));
for run = 1:Nruns
%     waitingasterisks( run,Nruns )
    xi                          = randsample( 1:length( x ),round(2*(length( x )/3)));
    ai                          =  x( xi );
    bi                          = y( xi );
    X                           = [ones( length( ai ),1 ) ai(:)];
    p                           = X\bi;
    %% linear fit
    linFit( run,: )         = p( 1 )+x.*p( 2 );
end

ci = permDist2CI( linFit,.025,'Normal' );
[k,d] = sort( x );
ci = ci( d,1 );

