clear all
close all hidden
clc


load( 'Ripple_Scaling.mat','H' )

%% ttest Nripples
A                                           = squeeze( mean( H ))
[h,p,ci,stat] = ttest( A( :,1 ),A( :,2 ))


X1                                          = GetOffset4OverlappingDataPoints( H( :,:,1 )',8,[1:3],200 );
X2                                          = GetOffset4OverlappingDataPoints( H( :,:,2 )',8,[5:7],200 );
figure; hold on
plot( X1,( H( :,:,1 ))','o','markeredgecolor','w','markerfacecolor','b' )
plot( X2,( H( :,:,2 ))','o','markeredgecolor','w','markerfacecolor','r' )
myaxis( 'Nback','N Ripples' )
plot( [1.2 1.8],H( 1:2,:,1 ),'color',[.5 .5 .5])
plot( [2.2 2.8],H( 2:3,:,1 ),'color',[.5 .5 .5])
plot( [5.2 5.8],H( 1:2,:,2 ),'color',[.5 .5 .5])
plot( [6.2 6.8],H( 2:3,:,2 ),'color',[.5 .5 .5])
xlim([0 8]);
% ylim([-100 4]);
set( gca,'xtick',[1:3 5:7],'xticklabel',{'2','3','4'} )


%% correlation of NRipples with Nback
NR                                          = H;


[r,p] = corrcoef( [[1:3]' NR( :,:,1 )]);
rr = r( 1,2:end );
[r,p] = corrcoef( [[1:3]' NR( :,:,2 )]);
rm = r( 1,2:end );
[h,p,ci,stat] = ttest( atanh( rr ),atanh( rm ))

%% plotting
figure; hold on
X                           = [rr' rm'];
Xi                          = GetOffset4OverlappingDataPoints( X,8,[1 2],200 );
plot( Xi( :,1 ),atanh( X( :,1 )),'o','markeredgecolor','w','markerfacecolor','b' )
plot( Xi( :,2 ),atanh( X( :,2 ))','o','markeredgecolor','w','markerfacecolor','r' )
xlim([0 3])
myaxis('condition','atanh( r )' )
plot( [1.3 1.7],atanh( X ),'color',[.7 .7 .7])
errorbar( [1.3 1.7],mean( [atanh( X )]),std( [atanh( X )])./sqrt( 21 ),'color',[.2 .2 .2],'linewidth',3,'capsize',0 )
set( gca,'xtick',[1 2],'XTickLabel',{'',''})
text( 1.5,7.5,['*'],'FontName','times','FontSize',30)
