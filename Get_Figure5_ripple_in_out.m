clear all
close all
clc



load( 'RippleInOutSpindle.mat')


%% plotting
Xi                                  = GetOffset4OverlappingDataPoints( X,8,[1 2],200 );
Yi                                  = GetOffset4OverlappingDataPoints( Y,8,[4 5],200 );


figure; hold on

drawBackgroundPatch([1.6 2.4],[0 3],[.9 .9 .9])
drawBackgroundPatch([4.6 5.4],[0 3],[.9 .9 .9])


plot( [1.2 1.8],X,'color',[.5 .5 .5])
E                                   = std( X )./sqrt( 21 );
M                                   = mean( X);
errorbar( [1.2 1.8],M,E,'color','k','capsize',0,'linewidth',2 )
[h,p,ci,stat]                       = ttest( X( :,1 ),X( :,2 ));
text( 1,2.5,['p = .83'],'fontname','times','fontsize',15 )

plot( [4.2 4.8],Y,'color',[.5 .5 .5])
E                                   = std( Y )./sqrt( 21 );
M                                   = mean( Y );
errorbar( [4.2 4.8],M,E,'color','k','capsize',0,'linewidth',2 )
[h,p,ci,stat]                       = ttest( Y( :,1 ),Y( :,2 ));
text( 4,2.5,['p < .001'],'fontname','times','fontsize',15 )



plot( Xi,X,'o','markeredgecolor','w','markerfacecolor','b' )
plot( Yi,Y,'o','markeredgecolor','w','markerfacecolor','r' )
xlim([-1 7])
myaxis('condition','ripplelikelihood' )
set( gca,'xtick',[1 2 4 5],'xticklabel',{'out','in'})
set( gca,'ytick',[0 1 2 3])
    

figure; hold on
drawBackgroundPatch([-.12 .12],[-7 7],[.9 .9 .9])
plot( rwin,zscore( squeeze( mean( WF ))),'linewidth',2 );
xlim([-.5 .5])
ylim([-6 6.5])
pbaspect([1 1 1])
myaxis('time to spindle trough','spindle amplitude' )
