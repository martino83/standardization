clc
clear
addpath src

vendors = {'Hitachi Aloka Medical,Ltd','TOSHIBA_MEC_US','ESAOTE',...
    'SAMSUNG MEDISON CO','Siemens','Philips Medical Systems','GE Vingmed Ultrasound'};
views = {'A4C','A3C','A2C'};
models = {'normal','ladprox','laddist','lcx','rca'};

for vendor = vendors
    num_nans = 0;
    num_points = 0;
    for model = models
        for view = views
            
            % -- gt
            gt_file = fullfile('data/ground_truth',[vendor{1},'_',view{1},'_',model{1},'.mat']);
            gt = load(gt_file);
            
            num_frames = size(gt.X_gt, 3);
            x0 = squeeze(gt.X_gt(:,1,1));
            z0 = squeeze(gt.X_gt(:,3,1));
            
            % plot nan points
            for n = 1:num_frames
                xp1 = squeeze(gt.X_gt(:,1,n));
                zp1 = squeeze(gt.X_gt(:,3,n));
                
                if (any(isnan([xp1(:), zp1(:)])) )
                    f = figure;
                    savename = ['tmp/',vendor{1},'_', model{1}, '_', view{1}, '_frame', num2str(n),'.png'];
                    plot(x0, z0, 'ko'); hold on;
                    id = isnan(xp1) | isnan(zp1);
                    plot(x0(id), z0(id), 'ko', 'MarkerFaceColor','r'); hold off;
                    title({vendor{1}, [model{1}, ' ', view{1}], ['frame ', num2str(n)]});
                    saveas(f, savename);
                    close(f)
                end
                
                num_points = num_points + numel(xp1);
                num_nans = num_nans + sum(isnan(xp1(:)) | isnan(zp1(:)));
            end
            
        end
    end
    
    fprintf('vendor %s: %d/%d nans\n', vendor{1}, num_nans, num_points);
end