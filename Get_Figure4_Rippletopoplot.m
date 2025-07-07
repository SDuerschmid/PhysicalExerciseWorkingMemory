clear all; close all; clc

aN                                      = [];
filename                                = 'rpts_loco.mat';
load( filename,'N','C','R' )

lR                                      = R;
lN                                      = N;
lC                                      = C;
aN                                      = cat( 2,aN,lN );

% a02_load_MEG_Ripples_loco.m
filename                                = 'rpts_rest.mat';
load( filename,'N','C','R' )

rR                                      = R;
rN                                      = N;
rC                                      = C;
aN                                      = cat( 2,aN,rN );


% color bar fig
cfg                 = topoprepare( 'Neuromag_helmet.mat' );
cfg.contournum      = 0;
cfg.electrodes      = 'off';
cfg.colorbar        = 'yes';
cfg.zlim = [-100 250];
subplot( 1,2,1 ),
toposhow( cfg,( mean( ( rN ),2 )) );

cfg  = topoprepare( 'Neuromag_helmet.mat' );
cfg.contournum      = 0;
cfg.electrodes      = 'off';
cfg.colorbar        = 'yes';
cfg.zlim = [-100 250];
subplot( 1,2,2 ),
toposhow( cfg,( mean( ( lN ),2 )) );
rmpath( 'ft4topoplot' )
