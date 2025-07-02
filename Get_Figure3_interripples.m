clear all
close all
clc


load('inter_ripple.mat')

time1 = [0:0.5:100-0.5];
mdis_li = mdis./sum(mdis,2);
rdis_li = rdis./sum(rdis,2);

ave_m = mean(mdis_li,1);
std_m = std(mdis_li,[],1)/(size(mdis,1)-1);

ave_r = mean(rdis_li,1);
std_r = std(rdis_li,[],1)/(size(rdis,1)-1);

b = bar(time1,[ave_m;ave_r]','BarWidth',1)
hold on
b(1).FaceColor = 'r';
b(2).FaceColor = 'b';
errorbar(time1-0.075,[ave_m]',[std_m]','.r')
errorbar(time1+0.075,[ave_r]',[std_r]','.b')
xlim([-0.5 5.3])
ylim([0 0.65])
% xticks([1 2])
% title('correction');
ylabel('Probability');
xlabel('Inter ripple interval [sec]');
hold off
