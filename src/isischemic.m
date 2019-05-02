function flag = isischemic(sequence, segment)

flag = zeros(numel(sequence),1);

for ii = 1:numel(sequence)
    
    [view, segment_id] = get_view_and_segment_id(segment{ii});
    
    if isnan(segment_id)
        flag(ii) = nan;
        continue
    end
        
    if strcmpi(sequence(ii),'laddist')
        switch view
            case 'A4C'
                is_ischemic_seq = [0 0 1 1 0 0];
            case 'A2C'
                is_ischemic_seq = [0 0 1 0 0 0];
            case 'A3C'
                is_ischemic_seq = [0 0 1 0 0 0];
        end
    end
    
    
    if strcmpi(sequence(ii),'ladprox')
        switch view
            case 'A4C'
                is_ischemic_seq = [0 0 1 1 1 0];
            case 'A2C'
                is_ischemic_seq = [0 0 1 0 0 0];
            case 'A3C'
                is_ischemic_seq = [0 1 1 0 0 0];
        end
    end
    
    if strcmpi(sequence(ii),'lcx') || strcmpi(sequence(ii),'cx')
        switch view
            case 'A4C'
                is_ischemic_seq = [1 1 0 0 0 0];
            case 'A2C'
                is_ischemic_seq = [0 0 0 0 0 0];
            case 'A3C'
                is_ischemic_seq = [0 0 0 0 1 1];
        end
    end
    
    if strcmpi(sequence(ii),'rca')
        switch view
            case 'A4C'
                is_ischemic_seq = [1 0 0 0 0 0];
            case 'A2C'
                is_ischemic_seq = [0 0 0 0 0 1];
            case 'A3C'
                is_ischemic_seq = [0 0 0 0 1 1];
        end
    end
    
    if strcmpi(sequence(ii),'normal')
        is_ischemic_seq = [0 0 0 0 0 0];
    end
    
    flag(ii) = is_ischemic_seq(segment_id);
    
end

end


