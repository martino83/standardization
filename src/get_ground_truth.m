function [val, gl_curve, L] = get_ground_truth(vendor,seq_id,view,type,layer,timing,varargin)

if nargin < 7 || isempty(varargin{1})
    segment_id = 0; else, segment_id = varargin{1}; end
if nargin < 8 || isempty(varargin{2})
    direction = 'longitudinal'; else, direction = varargin{2}; end

% input
% vendor, seq_id, view 
% type: global/segmental 
% layer; endo, mid, epi,
% timing: peackS/peakP/peakG/ES
% direction: 'radial/longitudinal(default)'
% segment id: relevant when type = segmental.

% output
% val - global value at time 'timing'
% gl_curbe - global curve;
% L - length over time;

% ES values. 1 counting!!!
ES = ES_frame(vendor);
fname = ['./data/ground_truth/',vendor,'_',view,'_',seq_id,'.mat'];
gt_strain = load(fname);

% -- compute strain
switch direction
    case 'longitudinal'
        
        switch type
            case 'global'
                dl = compute_arc_length_l(gt_strain.X_gt,layer);
                disp('Unused fields: segment_id');
                
            case 'segmental'
                if segment_id == 0
                    error('please assign valid segment in 1...6')
                end
                
                dl = compute_arc_length_l(gt_strain.X_gt(gt_strain.aha(:) == segment_id,:,:),layer);
                            
        end
        [val, gl_curve, L] = compute_global_strain(dl,timing,ES);
        
    case 'radial'
        disp('Unused fields: layer');
        switch type
            case 'global'
                dr = compute_arc_length_r(gt_strain.X_gt);
                disp('Unused fields: segment_id');
            case 'segmental'
                dr = compute_arc_length_r(gt_strain.X_gt(gt_strain.aha(:) == segment_id,:,:));
                
        end
        [val, gl_curve, L] = compute_global_strain_r(dr,timing,ES);
        
        
end
end

function [val, gL_curve, R] = compute_global_strain_r(R,timing,ES)

drift_comp = 1; % flag for drift compensation

gL_curve = 100 * (R - R(:,1)) ./ R(:,1);
% frame_ref = 50;
if drift_comp
    gL_curve = drift_compensation(gL_curve);
end

gL_curve = nanmean(gL_curve,1);
switch timing
    case 'ES' % end systolic 
        val = gL_curve(ES);
        
    case 'PeakS' 
        %         val = min(gL_curve);
        val = max(gL_curve(1:ES));
        
    case 'PeakG'
        val = max(gL_curve);
        %         val = min(gL_curve(ES:end));
        
    case 'PeakP'
        val = max(gL_curve);
        
    case 'PPS' % peak positive systolic
        val = max(gL_curve(1:ES));
        
    case 'PNS' % peak negative systolic
        val = min(gL_curve(1:ES));
        
    case 'PP' % peak positive (global)
        val = max(gL_curve);
    
    case 'PN' % peak negative (global)
        val = min(gL_curve);
end
debug();

end
