clc
close all
clear
addpath src

%% computes ground truth strain and saves it a excel file
%  'ground_truth_synthetic_data'

%% make table for global strain
% vendor = 'GE Vingmed Ultrasound';
% 
% seq_id = 'normal';
% view = 'A4C';
% noise = 0;
% layer = 'endo';

%% make table global strain
% A = {'ID','view','layer','GT','noise0','noise20','noise40','noise60','err0','err20','err40','err60'};
% B = {'ID','view','layer','Segment','GT','noise0','noise20','noise40','noise60','err0','err20','err40','err60'};

timing = 'ES';
cont_glob = 1;
cont_seg = 1;
ncases = 6*5*2*3*4;

for vendor = {'Hitachi Aloka Medical,Ltd','GE Vingmed Ultrasound','ESAOTE','Philips Medical Systems','SAMSUNG MEDISON CO','Siemens','TOSHIBA_MEC_US'}
    fname = 'ground_truth_synthetic_data';
    if exist('A','var')
        clear A;
    end
    
    cont = 1;
    A{cont,1} = 'ID';
    A{cont,2} = 'VIEW';
    A{cont,3} = 'LAYER';
    A{cont,4} = 'Segment';
    A{cont,5} = 'ES';
    A{cont,6} = 'PeakNegSyst';
    A{cont,7} = 'PeakPosSyst';
    A{cont,8} = 'PeakNeg';
    A{cont,9} = 'PeakPos';
    A{cont,10} = 'isIschemic';
    A{cont,11} = 'absmaxStrainET';
    
    for seq_id = {'normal','ladprox','laddist','rca','lcx'}
        for layer = {'endo','mid'}
            for view = {'A4C','A3C','A2C'}
                
                for segment_id = 0:6
                    
                    cont = cont + 1;
                    A{cont,1} = seq_id{1};
                    A{cont,2} = view{1};
                    A{cont,3} = layer{1};
                    
                    fprintf('%s %s %s %s %s %d\n', vendor{1}, seq_id{1}, layer{1}, view{1}, segment_id)
                    if segment_id == 0
                        A{cont,4} = 'Global';
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'global',layer{1},'ES',segment_id);
                        A{cont,5} = sprintf('%.2f ',val);
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'global',layer{1},'PNS',segment_id);
                        A{cont,6} = sprintf('%.2f ',val);
                        PNS = val;
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'global',layer{1},'PPS',segment_id);
                        A{cont,7} = sprintf('%.2f ',val);
                        PPS = val;
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'global',layer{1},'PN',segment_id);
                        A{cont,8} = sprintf('%.2f ',val);
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'global',layer{1},'PP',segment_id);
                        A{cont,9} = sprintf('%.2f ',val);
                        
                        A{cont,10} = sprintf('N/A');
                        
                        if PPS < 0
                            absmaxStrainET = PNS;
                        else
                            if PPS > -PNS
                                absmaxStrainET = PPS;
                            else
                                absmaxStrainET = PNS;
                            end
                        end
                        
                        A{cont,11} = sprintf('%.2f ',absmaxStrainET);
                        
                    else
                        
                        is_ischemic_seq = ischemic_segments(seq_id{1}, view{1});
                        is_ischemic = is_ischemic_seq(segment_id);
                      
                        selected_segment = extract_segment_label(vendor{1},view{1},segment_id);
                        A{cont,4} = selected_segment;
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'segmental',layer{1},'ES',segment_id);
                        A{cont,5} = sprintf('%.2f ',val);
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'segmental',layer{1},'PNS',segment_id);
                        PNS = val;
                        A{cont,6} = sprintf('%.2f ',val);
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'segmental',layer{1},'PPS',segment_id);
                        PPS = val;
                        A{cont,7} = sprintf('%.2f ',val);
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'segmental',layer{1},'PN',segment_id);
                        A{cont,8} = sprintf('%.2f ',val);
                        
                        val = get_ground_truth(vendor{1},seq_id{1},view{1},'segmental',layer{1},'PP',segment_id);
                        A{cont,9} = sprintf('%.2f ',val);
                        
                        A{cont,10} = sprintf('%d ',is_ischemic);
                        
                        if PPS < 0
                            absmaxStrainET = PNS;
                        else
                            if PPS > -PNS
                                absmaxStrainET = PPS;
                            else
                                absmaxStrainET = PNS;
                            end
                        end
                        
                        A{cont,11} = sprintf('%.2f ',absmaxStrainET);
                        
                    end
                end
            end
        end
    end
    xlswrite(fname,A,vendor{1})
end

