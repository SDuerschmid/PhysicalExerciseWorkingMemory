function propDensityplot( mx )


for k = 1:size( mx.dt,2 );
    h                           = [hist( mx.dt( :,k ),mx.y )];
    h                           = onezerostandard( STS( STS2( h,mx.sts( 1 )),mx.sts( 2 )));
    y                           = mx.dir( k ).*( h./mx.shrink ) + mx.x( k );
    xp                          = [mx.y mx.y( 1 )];
    yp                          = [y y( 1 )];
    v                           = [yp( :) xp(:)];
    patch( 'Faces',[1:length( v )],'vertices',v,'facecolor',mx.color( k,: ),'edgecolor','w' )
    hold on
end