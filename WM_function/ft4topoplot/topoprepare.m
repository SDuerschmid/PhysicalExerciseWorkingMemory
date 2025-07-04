function cfg = topoprepare(layoutfile,exclude)
% cfg = topoprepare(layoutfile,exclude)
% layoutfile can be a *.loc file or a *.mat layout file
% exclude defines sensores to be removed
% requires fieldtrip topoplot (old version, saved in ft4topoplot)

if strcmp(layoutfile(end-3:end),'.mat'),
    load(layoutfile);
    cfg.layout = lay;
    if nargin >1,
        cfg.layout.pos(exclude,:)=[];
        cfg.layout.width(exclude,:)=[];
        cfg.layout.height(exclude,:)=[];
        cfg.layout.label(exclude,:)=[];
    end
else
    [ch,cfg.X, cfg.Y,w,h,cfg.Lbl,r]=textread(layoutfile,'%f %f %f %f %f %q %q');
    if nargin>1,
        cfg.X(exclude)=[];
        cfg.Y(exclude)=[];
        cfg.Lbl(exclude)=[];
    end
end