function showMEG( x )


% x should be a column vector with 102 values
%% topoplot
addpath( '/export/data/reichert/toolbox/ft4topoplot' )
cfg                 = topoprepare( '/export/data/reichert/capLayout/Neuromag_helmet.mat' );
cfg.contournum      = 0;
cfg.electrodes      = 'off';
cfg.highlight       = [3 5 48 49 53 54 55 56 99 100 102];
cfg.highlight       = [75 76 77 78];
cfg.highlight       = [60 67 84 91];
toposhow( cfg,x );

rmpath( '/export/data/reichert/toolbox/ft4topoplot' )
