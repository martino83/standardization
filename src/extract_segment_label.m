function selected_segment = extract_segment_label(vendor,view,segment_id)

switch vendor
    
    case {'GE Vingmed Ultrasound','TomTec'}
        selected_segment = extract_segment_label_GE(view,segment_id);
        
    otherwise
        selected_segment = extract_segment_label_GE(view,segment_id);
        
end
end

function selected_segment = extract_segment_label_GE(view,segment_id)

switch view % establish correspondence between segment number and label
    
    case 'A4C'
        segment_number = 6:-1:1;
        segment_label = {'basSept',...
            'midSept',...
            'apSept',...
            'apLat',...
            'midLat',...
            'basLat'};
        
    case 'A2C'
        segment_number = 6:-1:1;
        segment_label = {'basInf',...
            'midInf',...
            'apInf',...
            'apAnt',...
            'midAnt',...
            'basAnt'};
        
    case 'A3C'
        segment_number = 1:6;
        segment_label = {'basAntSept',...
            'midAntSept',...
            'apAntSept',...
            'apPost',...
            'midPost',...
            'basPost'};
        
    otherwise
        error('no view with this name')
        
end

selected_segment = segment_label{segment_number == segment_id};

end