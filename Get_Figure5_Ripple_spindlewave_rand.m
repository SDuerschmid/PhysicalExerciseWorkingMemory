clear all
close all 
clc

rwin                                        = linspace( -1,1,1001 );
bsl                                         = [-1 -.7];
eegchannels                                 = [1 2] ;


%% original process
filename                                    = (['Ripple_EEG_coupling_m.mat']);
load( filename,'rtf' )

for c = 1:size( rtf,1 );
    rtf( c,:,:,: )                          = STS( zscoreBSL( squeeze( rtf( c,:,:,: )),[-1 1],bsl),1 );
end

RCM                                         = squeeze( mean( mean( rtf( :,eegchannels,:,: ),2 )));

filename                                    = (['Ripple_EEG_coupling.mat']);
load( filename,'rtf' )


for c = 1:size( rtf,1 );
    rtf( c,:,:,: )                          = STS( zscoreBSL( squeeze( rtf( c,:,:,: )),[-1 1],bsl),1 );
end

RCR                                         = squeeze( mean( mean( rtf( :,eegchannels,:,: ),2 )));

%% grandaverage
O                                           = ( RCM+RCR )./2;
M                                           = mean( O,2 );
E                                           = std( O,0,2 )./sqrt( 21 );



%% estimation of peak trough delay
maxwin                                      = find( rwin>-.05&rwin<0 );
minwin                                      = find( rwin>0&rwin<.05 );
for s = 1:21;
    [~,PT( s )]                             = max( O( maxwin,s ));
    [~,TT( s )]                             = min( O( minwin,s ));
end
    
Y                                           = diff([rwin( maxwin( PT(:)))' rwin( minwin( TT(:)))'],1,2 ).*1000;
Y( 13 )                                     = [];
Hz                                          = 1000./( Y.*2  );


%% figure 3 A-low frequency amplitude (Compare_Ripple_EEG_coupling_with_rand)
cdr = pwd;

rwin                                        = linspace( -1,1,1001 );
bsl                                         = [-1 -.7];
eegchannels                                 = [1 2] ;

% random process
filename                                    = (['Ripple_EEG_coupling_m_rand.mat']);
load( filename,'rtf' )

for c = 1:size( rtf,1 );
    rtf( c,:,:,: )                          = STS( zscoreBSL( squeeze( rtf( c,:,:,: )),[-1 1],bsl),1 );
end
RCM                                         = squeeze( mean( mean( rtf( :,eegchannels,:,: ),2 )));

filename                                    = (['Ripple_EEG_coupling_rand.mat']);
load( filename,'rtf' )

for c = 1:size( rtf,1 );
    rtf( c,:,:,: )                          = STS( zscoreBSL( squeeze( rtf( c,:,:,: )),[-1 1],bsl),1 );
end
RCR                                         = squeeze( mean( mean( rtf( :,eegchannels,:,: ),2 )));

% grandaverage
R                                           = ( RCM+RCR )./2;
M                                           = mean( R,2 );
E                                           = std( R,0,2 )./sqrt( 21 );

figure; hold on
drawBackgroundPatch( [-.014 0],[-1.5 1.5],[.9 .9 .9])
drawBackgroundPatch( [.01 .032],[-1.5 1.5],[.9 .9 .9])
shadedErrorBar( rwin,M,E,'k' )
line([0 0],[-1.5 1.5])
ylim([-1.5 1.5])
xlim([-.1 .1])
myaxis('time to ripple onset','amplitude' )

% original process
filename                                    = (['Ripple_EEG_coupling_m.mat']);
load( filename,'rtf' )

for c = 1:size( rtf,1 );
    rtf( c,:,:,: )                          = STS( zscoreBSL( squeeze( rtf( c,:,:,: )),[-1 1],bsl),1 );
end

RCM                                         = squeeze( mean( mean( rtf( :,eegchannels,:,: ),2 )));

filename                                    = (['Ripple_EEG_coupling.mat']);
load( filename,'rtf' )

for c = 1:size( rtf,1 );
    rtf( c,:,:,: )                          = STS( zscoreBSL( squeeze( rtf( c,:,:,: )),[-1 1],bsl),1 );
end
RCR                                         = squeeze( mean( mean( rtf( :,eegchannels,:,: ),2 )));

% grandaverage
O                                           = ( RCM+RCR )./2;
M                                           = mean( O,2 );
E                                           = std( O,0,2 )./sqrt( 21 );
shadedErrorBar( rwin,M,E,'m' )
line([0 0],[-1 1])
ylim([-1 1])
xlim([-.1 .1])
myaxis('time to ripple onset','amplitude' )

% %% plotting
peaktime                                    = rwin( maxwin( PT ));
Xi                                          = GetOffset4OverlappingDataPoints( peaktime(:), 8,1.15, 400 );
troughtime                                  = rwin( minwin( TT ));
Yi                                          = GetOffset4OverlappingDataPoints( troughtime(:), 8,.7, 400 );

errorbar( mean( [peaktime;troughtime],2 ),[1.1-0.02,0.8+0.02],std( [peaktime;troughtime],0,2 )./sqrt( 21),'color','k','capsize',10,'linewidth',3)
plot( peaktime,Xi,'o','markeredgecolor','w','markerfacecolor','r','markersize',5 )
plot( troughtime,Yi,'o','markeredgecolor','w','markerfacecolor','m','markersize',5 )
xlim([-.1 .1])
ylim([-1 1.5])




