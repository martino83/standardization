function play_scatter_map(read_dir,varargin)

if nargin < 2 || isempty(varargin{1})
    dB = 60; else dB = varargin{1}; end
if nargin < 3 || isempty(varargin{2})
    region = 'all'; else region = varargin{2}; end

flist = what(read_dir);
flist_m = flist.mat;
nfiles = numel(flist_m);
% dd = 2;

figure

for ii = 1:nfiles
    
    fname = [read_dir '/frame_' num2str(ii) '.mat'];
    load(fname);
    
    scat_x = [scat_x_fg(:);scat_x_bg(:)];
    scat_y = [scat_y_fg(:);scat_y_bg(:)];
    scat_z = [scat_z_fg(:);scat_z_bg(:)];
    ampl = [ampl_fg(:);ampl_bg(:)];
    nfg = numel(scat_x_fg);
    isin = abs(scat_z) < 1;    
    switch region 
        case 'fg'
            tt = (1:numel(scat_x))' <= nfg;
            isin = isin & tt;
        case 'bg'
            tt = (1:numel(scat_x))' > nfg;
            isin = isin & tt;
    end
    if ii == 1
        max_amp = max(abs(ampl));
    end
    ampl_db = (20*log10(abs(ampl)/max_amp) + dB)/dB * 255;    
    ampl_db(ampl_db<0) = 0;
    
    if ii == 1
        
        xmin = 0;
        ymin = min(scat_y(:));
        
        xmax = max(scat_x(:));
        ymax = max(scat_y(:));
        
    end
   
    dd = 1;
    scatter(scat_x(isin(1:dd:end)),scat_y(isin(1:dd:end)),5,ampl_db(isin(1:dd:end)),'filled');


    axis image
    xlim([xmin,xmax]);
    ylim([ymin,ymax]);
    pause(.1)
    
    caxis([0,255])
end

