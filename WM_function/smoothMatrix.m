function Y = smoothMatrix( X,w );

[szx,szy,szz] = size( X );
Y = X;

for d3 = 1:szz;
    for k = 1:szx;
        for kk = 1:szy;
            x = k-w:k+w;    %x coordinates
            y = kk-w:kk+w;  %y coordinates
            Y( k,kk,d3 ) = nanmean( nanmean( X( x( x > 0 & x < szx ), y( y > 0 & y < szy ))));
        end
    end
end