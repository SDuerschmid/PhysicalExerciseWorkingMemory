function plotCorrelationCI( x,y );


[a,b]               = sort( x );
[p,yhat,~,res]      = mylinearFit( a,y( b ) );
[ci,d]              = CorrelationCI( a,y( b ) );
shadedErrorBar( a( d ),yhat( d ),ci-yhat( d ))
