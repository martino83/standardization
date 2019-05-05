clc
clear
addpath src

vendors = {'Hitachi Aloka Medical,Ltd','TOSHIBA_MEC_US','ESAOTE',...
    'SAMSUNG MEDISON CO','Siemens','Philips Medical Systems','GE Vingmed Ultrasound'};
views = {'A4C','A3C','A2C'};
models = {'normal','ladprox','laddist','lcx','rca'};

num_nans = 0;
num_points = 0;
NUM_POINTS_REF = 180*numel(vendors)*numel(views)*numel(models);

for vendor = vendors
    for model = models
        for view = views
                        
            % -- gt
            gt_file = fullfile('data/ground_truth',[vendor{1},'_',view{1},'_',model{1},'.mat']);
            gt = load(gt_file);
            xp1 = squeeze(gt.X_gt(:,1,1));
            zp1 = squeeze(gt.X_gt(:,3,1));
            
            num_points = num_points + numel(xp1);
            num_nans = num_nans + sum(isnan(xp1) | isnan(zp1));
            
        end
    end
end

fprintf('%d/%d nans\n', num_nans, num_points);
assert(num_points == NUM_POINTS_REF)
