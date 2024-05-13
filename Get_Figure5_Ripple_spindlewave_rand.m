clear all
close all
clc

%% loading the data
load( 'rippletriggeredsindlewave_rand' )



figure; hold on
shadedErrorBar( rwin,Mr,Er,'k' )
shadedErrorBar( rwin,Mo,Eo,'m' )
line([0 0],[-1 1])
ylim([-1 1])
xlim([-.2 .2])
myaxis('time to ripple onset','amplitude' )





