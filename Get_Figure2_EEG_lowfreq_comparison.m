clear all
close all
clc




load( 'Spindle_timeseries' )

%% main effect condition
Er                                          = std( R,0,2 )./sqrt( 21 );
Ep                                          = std( P,0,2 )./sqrt( 21 );

figure; hold on
x                                           = [1 2 2 1 1];
y                                           = [-15 -15 35 35 -15];
v                                           = [x' y'];
patch( 'Faces',[1:5],'vertices',v,'facecolor',[.7 .7 .7],'edgecolor','w')
shadedErrorBar( time,mean( P,2 ),Ep,'r' );
shadedErrorBar( time,mean( R,2 ),Er,'b' )
myaxis( 'time [sec]','standardized amplitude' )
xlim([-.5 2.5]);
ylim([-15 35])
pbaspect([1 1 1])


