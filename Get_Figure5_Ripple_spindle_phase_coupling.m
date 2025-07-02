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
myaxisSmallFigure('spindle phase [rad]','frequency [Hz]')
set(gca, 'xtick', [-pi -pi/2 0 pi/2 pi],'xticklabel',{'-pi', '-pi/2', '0' ,'pi/2', 'pi'})

