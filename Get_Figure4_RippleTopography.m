clear all
close all hidden
clc



load( 'intersubjectcorrelation','R' )


%% intersubject correlation
Xl                                      = GetOffset4OverlappingDataPoints( R( :,2 ),8,2,500 );
Xr                                      = GetOffset4OverlappingDataPoints( R( :,1 ),8,1,500 );

%% ttest
[h,p,ci,stat] = ttest( atanh( R( :,1 )),atanh( R( :,2 )));

figure; hold on
plot( Xl,R( :,2 ),'o','markeredgecolor','w','markerfacecolor','r' )
plot( Xr,R( :,1 ),'o','markeredgecolor','w','markerfacecolor','b' )
plot( [1.3 1.7],R,'color',[.7 .7 .7])
errorbar( [1.3 1.7],mean( R ),std( R )./sqrt( 210 ),'color',[.2 .2 .2],'linewidth',3,'capsize',0 )
ylim([-.5 1])
xlim([0 3])
myaxis( 'condition','atanh( r )' )
set( gca,'xtick',1:2,'xticklabel',{'rest','locomotion'})
pbaspect([1 1 1])
