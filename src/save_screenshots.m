function save_screenshots(vendor,view_type,seq,es_id,varargin)

savefolder = 'videos_simulations';
mode = 'bck_on';

for ii = 1:2:numel(varargin)
    str = varargin{ii};
    val = varargin{ii+1};
    switch str
        case 'savefolder'
            savefolder = val;
        case 'mode'
            mode = val;
            
    end
end

srd_fname = fullfile('templates',vendor,[view_type '.srd']);
[~,~,USInfo] = load_templates(srd_fname);
% save(['info_' vendor '_' view_type '.mat'],'USInfo');

if strcmp(mode,'bck_on')
    simu_fname = fullfile('results',vendor,view_type,seq,'im_sim.mat');
else
    simu_fname = fullfile('results',vendor,view_type,seq,['im_sim_' mode '.mat']);
end

load(simu_fname);


gt_fname = ['ground_truth/' vendor '_' view_type '_' seq '.mat'];
load(gt_fname);
aha = ones(6,1)*(1:6); aha = aha(:); aha = aha * ones(1,5);

nframes = size(im_sim,3);
es_time = round(1/nframes * es_id * 1000);


savename_ed = fullfile(savefolder,[vendor '_' view_type '_' seq '_ED.png']);
savename_es = fullfile(savefolder,[vendor '_' view_type '_' seq '_ES.png']);

%% -- plot ED
xp = squeeze(X_gt(:,1,1));
zp = squeeze(X_gt(:,3,1));

x = linspace(0,USInfo.pixelsize(2)*USInfo.gridsize(2),USInfo.gridsize(2));
y = linspace(0,USInfo.pixelsize(1)*USInfo.gridsize(1),USInfo.gridsize(1));
imagesc(x,y,im_sim(:,:,1)), colormap gray, axis image, hold on
colors = 'rgbmyc';
for kk = 1:max(aha(:))
    plot(xp(aha==kk),zp(aha==kk),'ko','markerfacecolor',colors(kk),'markersize',4);
end
hold off
title('ED [frame = 1, time = 0ms]','fontsize',14);
cmd = ['export_fig ''' savename_ed ''' -painters'];
eval(cmd)


%% -- plot ES
xp = squeeze(X_gt(:,1,es_id));
zp = squeeze(X_gt(:,3,es_id));

x = linspace(0,USInfo.pixelsize(2)*USInfo.gridsize(2),USInfo.gridsize(2));
y = linspace(0,USInfo.pixelsize(1)*USInfo.gridsize(1),USInfo.gridsize(1));
imagesc(x,y,im_sim(:,:,es_id)), colormap gray, axis image, hold on
colors = 'rgbmyc';
for kk = 1:max(aha(:))
    plot(xp(aha==kk),zp(aha==kk),'ko','markerfacecolor',colors(kk),'markersize',4);
end
hold off
title(['ES [frame = 1, time = ' num2str(es_time) 'ms'],'fontsize',14);
cmd = ['export_fig ''' savename_es ''' -painters'];
eval(cmd)
