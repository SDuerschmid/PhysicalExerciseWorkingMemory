function [p,yhat,Res,singleRes] = mylinearFit( x,y );


x                               = x(:);
y                               = y(:);


X                               = [ones( length( x ),1 ) x(:)];
p                               = X\y;


%% linear fit
yhat                            = X*p;


%% residuals
singleRes                       = y-yhat;
Res                             = mean( ( y-yhat ).^2 );
