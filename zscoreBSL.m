function PC = zscoreBSL( Matrix,timeint,bslint )

%% matrix dimensions: time in the second dim
[x1 x2 x3 x4 x5]                = size( Matrix );
time                            = linspace( timeint( 1 ),timeint( 2 ),x2 );
bsl                             = find( time>bslint( 1 )&time<bslint( 2 ) );

%% only positive values
% Matrix              = (Matrix - min( Matrix(:)))+abs( nanmean( Matrix(:)));
% Matrix              = (Matrix - min( Matrix(:)))+.01;

bslavr                          = repmat( nanmean( Matrix( :,bsl,:,:,: ),2 ),[1 x2 1 1 1]);
bslstd                          = nanstd( Matrix( :,bsl,:,:,: ),0,2 );
bslstd( find( bslstd==0))       = min( nonzeros( bslstd ));
bslstd                          = repmat( bslstd,[1 x2 1 1 1]);
% bslstd( find( bslstd==0 ))      = .001;

PC                  = (Matrix-bslavr)./bslstd;

