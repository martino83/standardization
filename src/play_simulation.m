function play_simulation(vendor,view_type,seq,make_video,overlay_gt,varargin)

savefolder = 'videos_simulations';
mode = 'bck_on';
rewrite = false;
play_video = true;


for ii = 1:2:numel(varargin)
    str = varargin{ii};
    val = varargin{ii+1};
    switch str
        case 'savefolder'
            savefolder = val;
        case 'mode'
            mode = val;
        case 'rewrite'
            rewrite = val;
    end
end



srd_fname = fullfile('templates',vendor,[view_type '.srd']);
[~,~,USInfo] = load_templates(srd_fname);

save(['info_' vendor '_' view_type '.mat'],'USInfo');

if strcmp(mode,'bck_on')
    simu_fname = fullfile('results',vendor,view_type,seq,'im_sim.mat');
else
    simu_fname = fullfile('results',vendor,view_type,seq,['im_sim_' mode '.mat']);
end

load(simu_fname);

if overlay_gt == 1
    gt_fname = ['ground_truth/' vendor '_' view_type '_' seq '.mat'];
    load(gt_fname);
    %aha = ones(6,1)*(1:6); aha = aha(:); aha = aha * ones(1,5);
end

nframes = size(im_sim,3);

if make_video == 1
    if overlay_gt
        if strcmp(mode,'bck_on')
            savename = fullfile(savefolder,[vendor '_' view_type '_' seq '_gt']);
        else
            savename = fullfile(savefolder,[vendor '_' view_type '_' seq '_' mode '_gt']);
        end
    else
        if strcmp(mode,'bck_on')
            savename = fullfile(savefolder,[vendor '_' view_type '_' seq]);
        else
            savename = fullfile(savefolder,[vendor '_' view_type '_' seq '_' mode ]);
        end
    end
    
    if ~exist(savename,'file') || rewrite
        f = fileparts(savename); [~,~,~] = mkdir(f);
        writerObj = VideoWriter(savename);
        open(writerObj);
    else
        disp([savename,' already exists'])
        play_video = false;
    end
    %     mov(1:nframes) = struct('cdata', [],'colormap', []);
end


% --
if play_video
    for ii = 1:nframes
        if overlay_gt == 1
            xp = squeeze(X_gt(:,1,ii));
            % yp = squeeze(X_gt(:,2,ii));
            zp = squeeze(X_gt(:,3,ii));
        end
        
        x = linspace(0,USInfo.pixelsize(2)*USInfo.gridsize(2),USInfo.gridsize(2));
        y = linspace(0,USInfo.pixelsize(1)*USInfo.gridsize(1),USInfo.gridsize(1));
        imagesc(x,y,im_sim(:,:,ii)), colormap gray, axis image,
%         caxis([30,225])
        if overlay_gt
            hold on
            colors = 'rgbmyc';
            for kk = 1:max(aha(:))
                plot(xp(aha==kk),zp(aha==kk),'ko','markerfacecolor',colors(kk),'markersize',4);
            end
            hold off
        end
        if make_video
            frame = getframe;
            writeVideo(writerObj,frame);
            %         mov(kk+1) = getframe(gcf);
        end
        drawnow
    end
end

if ~exist(savename,'file') || rewrite
    if make_video
        close(writerObj);
        %     movie2avi(mov,savename,'compression','None','fps',nframes);
    end
end