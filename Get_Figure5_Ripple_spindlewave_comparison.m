clear all
close all
clc



%% loading the data
load( 'rippletriggeredspindlewave.mat','rtswRest','rtswLoco' )

figure; hold on
drawBackgroundPatch( [-.014 -.002],[-1 1],[.7 .7 .7])
drawBackgroundPatch( [.01 .032],[-1 1],[.7 .7 .7])
RCM                                         = squeeze( mean( mean( rtswLoco( :,1:3,:,: ),2 )));
M                                           = mean( RCM,2 );
E                                           = std( RCM,0,2 )./sqrt( 21 );
rwin                                        = linspace( -1,1,1001 );
shadedErrorBar( rwin,M,E,'r' )
xlim([-.1 .1])
line([0 0],[-1 1])
pbaspect([1 .5 1])
set( gca,'xtick',[-.1 0 .1])
set( gca,'ytick',[-1 0 1])
xlabel( 'time to ripple peak' )
ylabel( 'spindle amplitude' )



figure; hold on
drawBackgroundPatch( [-.016 -.002],[-1 1],[.7 .7 .7])
RCR                                         = squeeze( mean( mean( rtswRest( :,1:3,:,: ),2 )));
M                                           = mean( RCR,2 );
E                                           = std( RCR,0,2 )./sqrt( 21 );
rwin                                        = linspace( -1,1,1001 );
shadedErrorBar( rwin,M,E,'b' )
xlim([-.1 .1])
line([0 0],[-1 1])
ylim([-1 1])
pbaspect([1 .5 1])
set( gca,'xtick',[-.1 0 .1])
set( gca,'ytick',[-1 0 1])
xlabel( 'time to ripple peak' )
ylabel( 'spindle amplitude' )



%% ttest
[h,p,ci,stat]                               = ttest( RCR' );
T( 1,: )                                    = stat.tstat;
[h,p,ci,stat]                               = ttest( RCM' );
T( 2,: )                                    = stat.tstat;
