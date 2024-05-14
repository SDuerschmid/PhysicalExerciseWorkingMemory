Clear all
Close all
clc


load('ripshapeall.mat','ripshape_all')

srate = 500; % the sample rate
Ns = size(ripshape_all,2);
time = linspace(-1,1,length(-srate:srate));

M = mean(ripshape_all,2);
E = std(ripshape_all,0,2)./sqrt( Ns );


% interpolation with spline (makes shape less spiky)
itime = time(1):(0.1/length(time)):time(end);
Mi = interp1(time,M,itime,'spline');
Ei = interp1(time,E,itime,'spline');


% plot
figure;
shadedErrorBar(itime,Mi,Ei,{'color','k','LineWidth',2} )
xlim([-.1 .1])
yt = get(gca,'ylim');
ylim(yt)
line(get(gca,'xlim'),[0 0],'Color',[0.1 0.1 0.1],'LineStyle',':')
line([0 0],get(gca,'ylim'),'Color',[0.1 0.1 0.1],'LineStyle',':')
myaxis('Time (s)','MEG signal (µV)')


%% ripple time frequency
load( 'rtf_1-200.mat', 'RTF' )

rwin            = -srate:srate;
TF              = [];
TF              = cat( 4,TF,RTF );
time            = linspace( -1,1,length( rwin ));

F                         	= GetExponentialCenterFrequency( [1 200],50,.1 );

% baseline correction
rppbsl          = [1:400];
TF              = TF-repmat( nanmean( TF( :,:,rppbsl,: ),3 ),[1 1 1001 1]);
TF              = TF./repmat( nanstd( TF( :,:,rppbsl,: ),0,3 ),[1 1 1001 1]);
TF              = squeeze( mean( nanmean( TF,2 ),4 ));

% interpolation of frequency dimension
[Xi,Yi]         = meshgrid(linspace( 1,length( F ),100 ),1:length( time ) );
rtf             = interp2(TF',Xi,Yi )';

% frequency upside down
rtf             = rtf( end:-1:1,: );

m = linspace( 1,100,19 );
mark = num2str( round( mean( F( end:-2:1,: ),2 )));
figure('Units','centimeter','Position',[5 5 15 13])
imagesc( time,1,rtf )
set( gca,'ytick',m,'yticklabel',mark)
xlim([-0.2 0.2])
% ylim([1 40])
caxis([0 16])
myaxisSmallFigure('time [sec]','frequency [Hz]')
colorbar
set( gcf,'color',[1 1 1])

