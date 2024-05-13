clear all
close all
clc




load( 'ripple_spindle_phase_shift.mat' )

rr                                              = mean( RR );
re                                              = std( RR )./sqrt( 21 );


mm                                              = mean( MM );
me                                              = std( MM )./sqrt( 21 );

%% tests
[mmv,mmtp]                                      = max( MM' );
[rmv,rmtp]                                      = max( RR' );




figure; hold on
subplot( 3,1,1:2 )
shadedErrorBar( bincenter,mm,me,'r' )
hold on
shadedErrorBar( bincenter,rr,re,'b' )
Xi                                              = GetOffset4OverlappingDataPoints( rmtp',4,1,100 );
plot( bincenter( rmtp ),Xi,'o','markeredgecolor','w','markerfacecolor','b' )
Xi                                              = GetOffset4OverlappingDataPoints( rmtp',4,1.5,100 );
plot( bincenter( mmtp ),Xi,'o','markeredgecolor','w','markerfacecolor','r' )
myaxis('','standardized ripple likelihood' )
ylim([-1 1.7])
xlim([-pi pi])
set( gca,'xtick',[-pi -pi/2 0 pi/2 pi],'xticklabel',{'-pi','-pi/2','0','pi/2','p'})
pbaspect([.75 1 1])


subplot( 3,1,3 )
x                                               = linspace( 0,1,1000 );
y                                               = -cos( 2*pi*x ); 
ph                                              = linspace( -pi,pi,1000 );
plot( ph,y,'k')
pbaspect([1 .5 1])
set( gca,'xtick',[-pi -pi/2 0 pi/2 pi],'xticklabel',{'-pi','-pi/2','0','pi/2','p'})
xlim([-pi pi])
ylim([-2 2])
myaxis('spindle phase','' )

cmm                                             = circ_mean( bincenter( mmtp )');
[~,cmmtp]                                       = min( abs( ph-cmm ));                          
cmr                                             = circ_mean( bincenter( rmtp )');
[~,cmrtp]                                       = min( abs( ph-cmr ));                          
line([cmm cmm],[y( cmmtp ) 2],'color','r');
line([cmr cmr],[y( cmrtp ) 2],'color','b');


circ_ktest( bincenter( mmtp ),bincenter( rmtp ))
circ_wwtest( bincenter( mmtp ),bincenter( rmtp ))


