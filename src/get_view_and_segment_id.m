function [view, segment_id] = get_view_and_segment_id(segment)

view = nan;
segment_id = nan;
switch segment
    
    case 'basSept'
        view = 'A4C';
        segment_id = 6;
        
    case 'midSept'
        view = 'A4C';
        segment_id = 5;
        
    case 'apSept'
        view = 'A4C';
        segment_id = 4;
        
    case 'apLat'
        view = 'A4C';
        segment_id = 3;
        
    case 'midLat'
        view = 'A4C';
        segment_id = 2;
        
    case 'basLat'
        view = 'A4C';
        segment_id = 1;
        
    case 'basInf'
        view = 'A2C';
        segment_id = 6;
        
    case 'midInf'
        view = 'A2C';
        segment_id = 5;
        
    case 'apInf'
        view = 'A2C';
        segment_id = 4;
        
    case 'apAnt'
        view = 'A2C';
        segment_id = 3;
        
    case 'midAnt'
        view = 'A2C';
        segment_id = 2;
        
    case 'basAnt'
        view = 'A2C';
        segment_id = 1;
        
    case {'basAntSept', 'basAntSe'}
        view = 'A3C';
        segment_id = 1;
        
    case {'midAntSept', 'midAntSe'}
        view = 'A3C';
        segment_id = 2;
        
    case {'apAntSept', 'apAntSep'}
        view = 'A3C';
        segment_id = 3;
        
    case 'apPost'
        view = 'A3C';
        segment_id = 4;
        
    case 'midPost'
        view = 'A3C';
        segment_id = 5;
        
    case 'basPost'
        view = 'A3C';
        segment_id = 6;
        
    otherwise
        view = 'nan';
        segment_id = nan;
        
end

end