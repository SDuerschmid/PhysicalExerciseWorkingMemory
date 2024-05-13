clear all
close all
clc


load( 'ripple2spindleonset.mat' )

figure
% drawBackgroundPatch([-.12 .12],[1.6 2.8],[.9 .9 .9])
line([0 0],[1.6 2.8],'color','k')
hold on
plot( rwin,mean( X ),'linewidth',2)
myaxis('time [sec]','ripple likelihood' )
xlim([-.5 .5])
yyaxis right
ax                                  = gca;
ax.YAxis( 2 ).Color                 = 'k';
plot( rwin,S,'k','linewidth',2 )
myaxis('time [sec]','spindle amplitude [zscore]' )




%% colorcode
figure
PV                          = log10( STS( tpv,10 ));
PV( PV>-5 )                 = 0;
imagesc( rwin,1,PV )
xlim([-.5 .5])

cmap = [autumn;.7 .7 .7];
colormap( cmap )
pbaspect([1 .1 1])
axis off
colorbar
