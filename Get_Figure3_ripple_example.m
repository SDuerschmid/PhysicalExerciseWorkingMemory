clear all
close all
clc


load('ripple_example_data.mat')

% plot
figure('Units','centimeter','Position',[5 5 25 15])
subplot(4,1,1)
hold on
plot(time,data)
plot(time(ripple_duration(1):ripple_duration(2)),data(ripple_duration(1):ripple_duration(2)),'r')
% ylim([-8e-13 10e-13])
xlim(timezone)
xticks([1 2 3 4 5])
xticklabels({'','','','',''})
text(markloc, -5.5e-13,['1-200 Hz'],'FontSize',13)
ylabel('Macroelectrode');
hold off

subplot(4,1,2)
hold on
plot(time,data_filt)
plot(time(ripple_duration(1):ripple_duration(2)),data_filt(ripple_duration(1):ripple_duration(2)),'r')
% ylim([-3e-13 3e-13])
xlim(timezone)
xticks([1 2 3 4 5])
xticklabels({'','','','',''})
text(markloc, -2.5e-13,['80-150 Hz'],'FontSize',13)
ylabel('Ripple band');
hold off

subplot(4,1,3)
hold on
plot(time,data_enve)
plot(time(ripple_duration(1):ripple_duration(2)),data_enve(ripple_duration(1):ripple_duration(2)),'r')
% ylim([0 2.5e-13])
xlim(timezone)
xticks([1 2 3 4 5])
xticklabels({'','','','',''})
text(markloc, 2.1e-13,['80-150 Hz'],'FontSize',13)
ylabel('Ripple band envelope');
hold off

subplot(4,1,4)
A   = Y( :,:,end:-1:1);
ga  = squeeze( mean(A,1));
[Xi,Yi] = meshgrid(linspace( 1,length( F ),100 ),1:length( time ) );
gai     = interp2(ga,Xi,Yi )';
mar = linspace( 1,100,length( F( end:-2:1,: )) );
lab = round( mean( F( end:-2:1,: ),2 ));
imagesc( time,1,gai )
set( gca,'ytick',mar(1,[4,21]),'yticklabel',num2str(lab([4,21])))
xlim(timezone)
% caxis([2e-14 12e-14])
xticks([1 2 3 4 5])
xticklabels({'','','','',''})
ylabel('Power spectrogram')
c= colorbar;
c.Location = 'manual';
c.Position = [0.86 0.13 0.02 0.11]

% saveas(gcf,'/export/data/Xinyun/locomotion/ripple_example.png')
% saveas(gcf,'/export/data/Xinyun/locomotion/ripple_example.svg')
