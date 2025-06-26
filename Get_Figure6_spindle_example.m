clear all
close all
clc

load('spindle_example_data.mat')

% plot
figure('Units','centimeter','Position',[5 5 25 15])
subplot(4,1,1)
hold on
plot(time,data)
plot(time(spindle_durat(1):spindle_durat(2)),data(spindle_durat(1):spindle_durat(2)),'r')
xticks([1 2 3 4 5])
xticklabels({'','','','',''})
text(0.25, 1.5e-5,['1-200 Hz'],'FontSize',13)
ylabel('raw data');
hold off

subplot(4,1,2)
hold on
plot(time,data_filt)
plot(time(spindle_durat(1):spindle_durat(2)),data_filt(spindle_durat(1):spindle_durat(2)),'r')
xticks([1 2 3 4 5])
xticklabels({'','','','',''})
text(0.25, -.5e-5,['13-20 Hz'],'FontSize',13)
ylabel('spindle band');
hold off

subplot(4,1,3)
hold on
plot(time,data_enve)
plot(time(spindle_durat(1):spindle_durat(2)),data_enve(spindle_durat(1):spindle_durat(2)),'r')
xticks([1 2 3 4 5])
xticklabels({'','','','',''})
text(0.25, .5e-5,['13-20 Hz'],'FontSize',13)
ylabel('spindle band envelope');
hold off

subplot(4,1,4)
A   = Y( :,:,end:-1:1);
ga  = squeeze( mean(A,1));
[Xi,Yi] = meshgrid(linspace( 1,length( F ),100 ),1:length( time ) );
gai     = interp2(ga,Xi,Yi )';
mar = linspace( 1,100,length( F( end:-2:1,: )) );
lab = round( mean( F( end:-2:1,: ),2 ));
imagesc( time,1,gai )
set( gca,'ytick',mar,'yticklabel',num2str(lab))
xticks([0 1 2 3 4])
ylabel('Power spectrogram')
c= colorbar;
c.Location = 'manual';
c.Position = [0.86 0.13 0.02 0.11];