function is_ischemic_seq = ischemic_segments(sequence, view)

%%% tell whether is ischemic
if strcmp(sequence,'laddist')
    switch view
        case 'A4C'
            is_ischemic_seq = [0 0 1 1 0 0];
        case 'A2C'
            is_ischemic_seq = [0 0 1 0 0 0];
        case 'A3C'
            is_ischemic_seq = [0 0 1 0 0 0];
    end
end

if strcmp(sequence,'ladprox')
    switch view
        case 'A4C'
            is_ischemic_seq = [0 0 1 1 1 0];
        case 'A2C'
            is_ischemic_seq = [0 0 1 0 0 0];
        case 'A3C'
            is_ischemic_seq = [0 1 1 0 0 0];
    end
end

if strcmp(sequence,'lcx')
    switch view
        case 'A4C'
            is_ischemic_seq = [1 1 0 0 0 0];
        case 'A2C'
            is_ischemic_seq = [0 0 0 0 0 0];
        case 'A3C'
            is_ischemic_seq = [0 0 0 0 1 1];
    end
end

if strcmp(sequence,'rca')
    switch view
        case 'A4C'
            is_ischemic_seq = [1 0 0 0 0 0];
        case 'A2C'
            is_ischemic_seq = [0 0 0 0 0 1];
        case 'A3C'
            is_ischemic_seq = [0 0 0 0 1 1];
    end
end

if strcmp(sequence,'normal')
    is_ischemic_seq = [0 0 0 0 0 0];
end
