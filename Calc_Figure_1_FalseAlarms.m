clear all
close all hidden
clc


addpath( 'C:\Users\stefa\OneDrive\Experimente\allscripts')

%% loading the data
filename            = ['meg_falsealarms.mat'];


load( filename )


%% averageing across minutes and Nbacks
B                   = [mean( Rf( :,: ),2 ) mean( Pf( :,: ),2 ) ];

%% plotting the 
Xi                  = GetOffset4OverlappingDataPoints( B,8,1:2,200 );
color               = {'b','r'};
figure; hold on
for k = 1:2;
    plot( Xi( :,k ),B( :,k ),'o','MarkerEdgeColor','w','MarkerFaceColor',color{ k });
end
plot( [1.2 1.8],B,'color',[.7 .7 .7])
errorbar( [1.2 1.8],mean( B ),std( B )./sqrt( 21 ),'color',[.3 .3 .3],'LineWidth',3,'CapSize',0 )
myaxis('','performance' )
set( gca,'xtick',[1 2],'XTickLabel',{'',''})
set( gca,'ytick',[0 .1 .2])
xlim([0 3])
ylim([0 .2])

%% ttest
[h,p,ci,stat]        = ttest( B( :,1 ),B( :,2 ));
text( 1.3,.15,['n.s.'],'FontName','times','FontSize',30)



%% now we look into the differente N-backs
H                       = cat( 3,mean( Rf,3 ),mean( Pf,3 ));
[Nsubj, Nback,Ncond]    = size( H );

%% ttest
for n = 1:3;
    [h,p,ci,stat]       = ttest( H( :,n,1 ),H( :,n,2 ));
    T( n )              = stat.tstat;
    P( n )              = p;
end

%% looking at the data
x                       = [1 2; 5 6; 9 10];
signum                  = {'n.s.','+','n.s.'}
figure; hold on
for n = 1:3;
    Xi                  = GetOffset4OverlappingDataPoints( squeeze( H( :,n,: )),8,x( n,: ),100 );
    plot( Xi( :,1 ),squeeze( H( :,n,1 )),'o','MarkerEdgeColor','w','MarkerFaceColor','b');
    plot( Xi( :,2 ),squeeze( H( :,n,2 )),'o','MarkerEdgeColor','w','MarkerFaceColor','r');
    plot( [x( n,1 )+.3 x( n,2 )-.3],squeeze( H( :,n,: )),'color',[.7 .7 .7])
    errorbar( [x( n,1 )+.3 x( n,2 )-.3],...
        squeeze( mean( H( :,n,: ))),...
        squeeze( std( H( :,n,: )))./sqrt( 21 ),...
        'color',[.3 .3 .3],'LineWidth',2,'CapSize',0 )
    line([x( n,: )],[1.1 1.1],'color','k')
    text( x( n,1 ),.15,[signum{ n }],'FontName','times','FontSize',30)
end
myaxis('','performance' )
set( gca,'xtick',[1.5 5.5 9.5],'XTickLabel',{'2','3','4'})
set( gca,'ytick',[0 .1 .2])
xlim([0 11])
ylim([-.05 .2])


