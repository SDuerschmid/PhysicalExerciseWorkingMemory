clear all; close all; clc

filename                                    = 'Nripples_sigchans_Nback.mat';
load( filename )
load Performance4Katze.mat
H                                           = permute( H,[2 1 3]);

A                                           = reshape( diff( H,1,3 ),63,[]);
B                                           = reshape( permute( diff( Crts,1,4 ),[1 3 2]),63,[] );
[r,p]                                       = corrcoef( [A B]);

% typical time course
L                                           = zscoreBSL( Crts( :,:,:,2 ),[nt( 1 ) nt( end )],[-.5 0]);
R                                           = zscoreBSL( Crts( :,:,:,1 ),[nt( 1 ) nt( end )],[-.5 0]);
DT                                          = cat( 4,R,L );
X                                           = squeeze( mean( mean( DT,4 )));
M                                           = mean( X,2 );
E                                           = std( X,0,2 )./sqrt( 21 );

figure; hold on
subplot( 1,2,1 )
hold on
X                                           = squeeze( mean( R ));
M                                           = mean( X,2 );
E                                           = std( X,0,2 )./sqrt( 21 );
shadedErrorBar( nt,M,E,{'color','b','markerfacecolor','b'});
X                                           = squeeze( mean( L ));
M                                           = mean( X,2 );
E                                           = std( X,0,2 )./sqrt( 21 );
shadedErrorBar( nt,M,E,{'color','r','markerfacecolor','r'});
myaxis('time [sec]','Ripple likelihood' )
ylim([-3 2])
xlim([-.5 2.5])
pbaspect([1 1 1])
subplot( 1,2,2 )
[h,p,ci,stat] = ttest( squeeze( mean( R ))' )
plot( nt,stat.tstat,'b' )
xlim([-.5 2.5])
[h,p,ci,stat] = ttest( squeeze( mean( L ))' );
hold on
plot( nt,stat.tstat,'r' )
myaxis('time [sec]','t-value' )
xlim([-.5 2.5])
ylim([-6 6])
pbaspect([1 1 1])

% ripple-performance correlation 
L                                           = zscoreBSL( Crts( :,:,:,2 ),[nt( 1 ) nt( end )],[-.5 0]);
R                                           = zscoreBSL( Crts( :,:,:,1 ),[nt( 1 ) nt( end )],[-.5 0]);
DT                                          = cat( 4,R,L );
dt                                          = squeeze( mean( mean( DT,4 )));
X                                           = squeeze( mean( mean( DT,4 )));
M                                           = mean( X,2 );
E                                           = std( X,0,2 )./sqrt( 21 );

figure; hold on
hold on
x                                           = [0 1 1 0 0];
y                                           = [-3 -3 2 2 -3];
v                                           = [x' y'];
patch( 'Faces',[1:5],'vertices',v,'facecolor',[1 0.67 0.67],'edgecolor','w' )


x                                           = [1.5 2.5 2.5 1.5 1.5];
y                                           = [-3 -3 2 2 -3];
v                                           = [x' y'];
patch( 'Faces',[1:5],'vertices',v,'facecolor',[.9 .9 .9],'edgecolor','w' )
shadedErrorBar( nt,M,E )
xlim([-.5 2.5])
ylim([-3 2])
pbaspect([1 1 1])
myaxis('time','Ripple likelihood' )

% compare with performance
h                                           = squeeze( mean( mean( H,3 )));
[~,rh]                                      = sort( h );

% ttest
aws                                         = [0 1.5];
for a = 1:length( aws )
    awin                                    = find( nt>aws( a )&nt<aws( a )+1);
    awrn( a )                               = round( mean( awin ));
    X                                       = mean( dt( awin,: ))';
    [r,p]                                   = corrcoef( rh',X );
    rv( a,: )                               = [p( 1,2 ) r( 1,2 )];
    figure
    hold on
    plotCorrelationCI( zscore( rh ),zscore( X ))
    plot( zscore( rh ),zscore( X ),'o','markeredgecolor','w','markerfacecolor','k' )
    myaxis('performance','N Ripples' )
    ylim([-3 2])
    xlim([-2 2])
    if a == 1
        text( -0.5,2.1,['n.s.'],'FontName','times','FontSize',30)
    else
        text( -0.2,2.1,['*'],'FontName','times','FontSize',30)
    end
    pbaspect([.5 1 1])
end