function [convsig,ntime] = mkconvolution( rastermatrix,timeint,srate,convInt );

[x1 x2 x3]                      = size( rastermatrix );
time                            = linspace( timeint( 1 ),timeint( 2 ),x2 );
sampInt                         = round( srate*convInt );
convsig                         = STS( STS2( rastermatrix,sampInt ),round( sampInt./5 ));
ntime                           = time+convInt;
