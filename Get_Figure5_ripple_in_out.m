clear all
close all
clc


load('spindle_inout_rest')
X = [In',Out'];

load('spindle_inout_move')
Y = [In',Out'];

% plotting
Xi                                  = GetOffset4OverlappingDataPoints( X,8,[1 2],200 );
Yi                                  = GetOffset4OverlappingDataPoints( Y,8,[4 5],200 );

figure; hold on
drawBackgroundPatch([1.6 2.4],[0 3],[.9 .9 .9])
drawBackgroundPatch([4.6 5.4],[0 3],[.9 .9 .9])
plot( [1.2 1.8],X( :,[2 1]),'color',[.5 .5 .5])
E                                   = std( X( :,[2 1]))./sqrt( 21 );
M                                   = mean( X( :,[2 1]));
errorbar( [1.2 1.8],M,E,'color','k','capsize',0,'linewidth',2 )
[h,p,ci,stat]                       = ttest( X( :,1 ),X( :,2 ));
text( 1.3,2.6,['n.s.'],'FontName','times','FontSize',30)

plot( [4.2 4.8],Y( :,[2 1]),'color',[.5 .5 .5])
E = std( Y( :,[2 1]))./sqrt( 21 );
M = mean( Y( :,[2 1]));
errorbar( [4.2 4.8],M,E,'color','k','capsize',0,'linewidth',2 )
[h,p,ci,stat]                       = ttest( Y( :,1 ),Y( :,2 ));
text( 4.3,2.55,['**'],'FontName','times','FontSize',30)

plot( Xi,X( :,[2 1]),'o','markeredgecolor','w','markerfacecolor','b' )
plot( Yi,Y( :,[2 1]),'o','markeredgecolor','w','markerfacecolor','r' )
xlim([-1 7])
ylim([0 2.5])
myaxis('condition','ripple density' )
set( gca,'xtick',[1 2 4 5],'xticklabel',{'out','in'})
