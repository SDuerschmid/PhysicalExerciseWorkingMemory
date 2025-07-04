function [ci] = permDist2CI( permDist,threshold,distributiontype )

[Nruns,Npoints] = size( permDist );
ci = zeros( Npoints,2 );
for tp = 1:Npoints;
    x = permDist( :,tp );
    p = cdf( distributiontype,x,mean( x ),std( x ));
    y = sort(x(find( p >= 1-threshold )));
    if isempty( y ) == 1;
        xx = x(find( p == max( p )));
        ci( tp,1 ) = xx( 1 );
    else
        ci( tp,1 ) = y( 1 );
    end

    y = sort(x(find( p <= threshold )));
    if isempty( y ) == 1;
        xx = x(find( p == min( p )));
        ci( tp,2 ) = xx( end );
    else
        ci( tp,2 ) = y( end );
    end
end
