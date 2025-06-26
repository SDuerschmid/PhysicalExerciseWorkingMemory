clear all
close all
clc

rwin                                = linspace( -3,3,3001 );

sampint                             = .01;
spinstart                           = find( rwin>-.1&rwin<-.0 );
spinend                             = find( rwin>.0&rwin<.1 );

spamp                               = 1:4;
%% rest
filename                            = (['EEGThetaburst_ripple_spindle.mat']);
load( filename )
kk                                  = STS( mkconvolution( K,[-0.5 3],500,sampint ),round( 500*sampint ));
kkavr( :,:,1 )                      = kk;
KR                                  = K( :,:,1 );

%% locomotion
filename                            = (['EEGThetaburst_ripple_spindle_m.mat']);
load( filename )
kk                                  = STS( mkconvolution( K,[-0.5 3],500,sampint ),round( 500*sampint ));
kkavr( :,:,2 )                      = kk;
KP                                  = K( :,:,1 );
K                                   = cat( 3,KP,KR );


% %% zero crossings
WF1 = splitapply(@(a) envelope(a), WF, [1:1:21]');
S                                   = zscore( STS( mean( WF1( :,:,1 )),10 ));
X                                   = mean( STS( K,20 ),3 );


%% permutation
for r = 1:1e3;
    waitingasterisks( r,1e3 )
    Ki                              = bsxfun( @circshift,K( :,: )',randsample( 1:length(rwin)*2,21 ))';
    Ki                              = reshape( Ki,size( K ));
    Y( r,: )                        = mean( mean( STS( Ki,20 ),3 ));
end


for t = 1:3001;
    x                               = [mean( X( :,t )) Y( :,t )'];
    p                               = cdf( 'Normal',x,mean( x ), std( x ));
    Pv( t )                         = 1-p( 1 );
    [h,p,ci,stat]                   = ttest2( X( :,t ),Y( :,t ));
    tv( t )                         = stat.tstat;
    tpv( t )                        = p;
end


figure
line([0 0],[-2 3],'color','k')
hold on
plot( rwin,zscore(mean( X )),'Color',FF_color('b'),'linewidth',2)
myaxis('time [sec]','ripple likelihood [zscore]' )
xlim([-3 3])
yyaxis right
ax                                  = gca;
ax.YAxis( 2 ).Color                 = 'k';
plot( rwin,zscore(S),'k','linewidth',2 )
myaxis('time [sec]','spindle amplitude [zscore]' )

