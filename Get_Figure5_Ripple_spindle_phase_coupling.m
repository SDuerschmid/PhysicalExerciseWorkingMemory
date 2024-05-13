clear all
close all
clc



load( 'ripple_spindle_phase_coupling.mat','rtf','nf','bincenter' )



gartf                                           = rtf; 
% nf                                              = num2str( round( mean( F( end:-1:1,: ),2 )));

figure
imagesc( bincenter,1,mean( gartf,3 ))
set( gca,'ytick',linspace( 1,100,length( nf )),'yticklabel',nf )
pbaspect([1 1 1])
ylim([50 100])
myaxisSmallFigure('time [sec]','frequency [Hz]')
