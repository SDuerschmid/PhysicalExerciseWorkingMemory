clear all
close all
clc





filename                                    = 'EEG_lowfreq_tf.mat';
load( filename )

%% plotting
figure
imagesc( time,1,LF )
set( gca,'ytick',linspace( 1,100,length( F( end:-2:1,: )) ),'yticklabel',num2str( round( mean( F( end:-2:1,: ),2 ))))
xlim([-.5 2.5])
pbaspect([1 1 1])
ylim([1 90])
caxis([-30 30 ])
xlabel('time [sec]')
ylabel('frequency [Hz]')
colorbar

