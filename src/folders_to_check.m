function [dir_to_remove,dir_to_check] = folders_to_check(vendor)

view_vec = {'A2C','A3C','A4C'};
seq_vec = {'rca','lcx','ladprox','laddist','normal'};

switch vendor
    case 'TOSHIBA_MEC_US'
        frame_rate = '60';
    case 'Siemens'
        frame_rate = '56';
    case 'Hitachi Aloka Medical,Ltd'
        frame_rate = '72';
    case 'GE Vingmed Ultrasound'
        frame_rate = '54';
    case 'ESAOTE'
        frame_rate = '54';
    case 'Philips Medical Systems'
        frame_rate = '50';
    case 'SAMSUNG MEDISON CO'
        frame_rate = '65';
end

dir_to_check = {};
dir_to_remove = {};
for jj = 1:numel(view_vec)
    view_type = view_vec{jj};
    for kk = 1:numel(seq_vec)
        seq = seq_vec{kk};
        d = {fullfile('results',vendor,view_type,seq,'scatterers_coherent'),...
            fullfile('results',vendor,view_type,seq,'scatterers_incoherent'),...
			fullfile('results',vendor,view_type,seq,'scatterers'),...
            fullfile('results',vendor,view_type,seq,'rf_sim'),...
            fullfile('results',vendor,view_type,seq,'pre_stored','BC_incoher_2000000'),...
            fullfile('results',vendor,view_type,seq,'rf_sim_bck_off')};
        dir_to_check = [dir_to_check,d];
    end
end

for ii = 1:numel(dir_to_check)
    
    if exist(dir_to_check{ii},'dir')
        s = what(dir_to_check{ii});
        if numel(s.mat) < frame_rate;
            dir_to_remove = [dir_to_remove;dir_to_check{ii}];
        end
        
    end
end
debug();

