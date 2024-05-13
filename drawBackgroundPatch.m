function drawBackgroundPatch( x,y,color )


x                                           = [x( 1) x( 2 ) x( 2 ) x( 1 ) x( 1 )];
y                                           = [y( 1 ) y( 1 ) y( 2 ) y( 2 ) y( 1 )];
v                                           = [x' y'];
patch( 'Faces',[1:5],'vertices',v,'facecolor',color,'edgecolor','w' )
