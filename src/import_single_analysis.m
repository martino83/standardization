function val = import_single_analysis(vendor,seq_id,view,noise,type,layer,timing,segment_id)

switch vendor
    case 'GE Vingmed Ultrasound'
        val = import_GE_strain(type,seq_id,noise,view,layer,timing,segment_id);
        
    case 'TomTec'
        val = import_TomTec_strain(type,seq_id,noise,view,layer,timing,segment_id);
        
    otherwise
        error('undefined vendor')
end

end

function val = import_GE_strain(type,seq_id,noise,view,layer,timing,segment_id)

switch type
    case 'global'
        val = import_GE_global_strain(seq_id,noise,view,layer);
        disp('Unused fields: segment_id');
        
    case 'segmental'
        val = import_GE_segmental_strain(seq_id,noise,view,layer,timing,segment_id);
        
    otherwise
        error('Undefined type. Admitted choices: global, segmental');
end


end

function val = import_TomTec_strain(type,seq_id,noise,view,layer,timing,segment_id)

switch type
    case 'global'
        val = import_TomTec_global_strain(seq_id,noise,view,layer);
        disp('Unused fields: segment_id');
        
    case 'segmental'
        val = import_TomTec_segmental_strain(seq_id,noise,view,layer,timing,segment_id);
        
    otherwise
        error('Undefined type. Admitted choices: global, segmental');
end


end

function val = import_TomTec_global_strain(seq_id,noise,view,layer)

xls_file = '../AnalysisAssami/tblSpeckleMacro';
[~,~,raw] = xlsread(xls_file,1); % global

seq_col = strcmpi(raw(1,:),'pasient_code');
noise_col = strcmpi(raw(1,:),'stoy');
seg_col = strcmpi(raw(1,:),'segment');

switch noise
    case 0
        noise_val = 1;
    case 20
        noise_val = 1;
    case 40
        noise_val = 3;
    case 60
        noise_val = 4;
end

switch lower(seq_id)
    case 'laddist' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 21;
    case 'ladprox' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 22;
    case 'lcx' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 23;
    case 'normal' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 24;
    case 'rca' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 25;
end

seq_selector = seq_selector & (read_numeric_entry(raw,noise_col) == noise_val ) & strcmpi(raw(:,seg_col),'Global');

% rename view
switch view
    case 'A4C'
        view_tag = '4CH';
    case 'A2C'
        view_tag = '2CH';
    case 'A3C'
        view_tag = 'APLAX';
end

switch layer
    case 'endo'
        layer_tag = 'Endo';
    case 'mid'
        layer_tag = 'Myo';
    case 'epi'
        layer_tag = 'Epi';
end

view_col = strcmpi(raw(1,:),'projection');
view_selector = strcmpi(raw(:,view_col),view_tag);

study_col = strcmpi(raw(1,:),'observer');
study_val = read_numeric_entry(raw,study_col);

layer_col = strcmpi(raw(1,:),'location');
layer_selector = strcmpi(raw(:,layer_col),layer_tag);

% -- read strain
data_col = strcmpi(raw(1,:),'minStrainAll');
g_strain_val = read_numeric_entry(raw,data_col);

val = nan(3,1);
for study_no = 1:3
    id_select = seq_selector & ...
        view_selector & ...
        (study_val == study_no) & ...
        layer_selector;
    val(study_no) =  mean(g_strain_val(id_select)); % sometimes they are replicated
end

end

function val = import_TomTec_segmental_strain(seq_id,noise,view,layer,timing,segment_id)

selected_segment = extract_segment_label('GE Vingmed Ultrasound',view,segment_id);

xls_file = '../AnalysisAssami/tblSpeckleMacro';
[~,~,raw] = xlsread(xls_file,1); % global

seq_col = strcmpi(raw(1,:),'pasient_code');
noise_col = strcmpi(raw(1,:),'stoy');
seg_col = strcmpi(raw(1,:),'segment');

switch noise
    case 0
        noise_val = 1;
    case 20
        noise_val = 1;
    case 40
        noise_val = 3;
    case 60
        noise_val = 4;
end

switch lower(seq_id)
    case 'laddist' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 21;
    case 'ladprox' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 22;
    case 'lcx' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 23;
    case 'normal' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 24;
    case 'rca' % in one case it's called cx instead of lcx
        seq_selector = read_numeric_entry(raw,seq_col) == 25;
end

seq_selector = seq_selector & ...
    (read_numeric_entry(raw,noise_col) == noise_val ) & ...
    strcmpi(raw(:,seg_col),selected_segment);

% rename view
switch view
    case 'A4C'
        view_tag = '4CH';
    case 'A2C'
        view_tag = '2CH';
    case 'A3C'
        view_tag = 'APLAX';
end

switch layer
    case 'endo'
        layer_tag = 'Endo';
    case 'mid'
        layer_tag = 'Myo';
    case 'epi'
        layer_tag = 'Epi';
end

view_col = strcmpi(raw(1,:),'projection');
view_selector = strcmpi(raw(:,view_col),view_tag);

study_col = strcmpi(raw(1,:),'observer');
study_val = read_numeric_entry(raw,study_col);

layer_col = strcmpi(raw(1,:),'location');
layer_selector = strcmpi(raw(:,layer_col),layer_tag);

% -- read strain
data_col = strcmpi(raw(1,:),'minStrainAll');
g_strain_val = read_numeric_entry(raw,data_col);

val = nan(3,1);
for study_no = 1:3
    id_select = seq_selector & ...
        view_selector & ...
        (study_val == study_no) & ...
        layer_selector;
    val(study_no) =  mean(g_strain_val(id_select));
end

end


function val = import_GE_segmental_strain(seq_id,noise,view,layer,timing,segment_id)

selected_segment = extract_segment_label('GE Vingmed Ultrasound',view,segment_id);

% if ~ismember(segment_id,legal_segments)
%     error('Undefined Segment for this view');
% end


xls_file = '../AnalysisAssami/GE_2DSTM120_2016_12_13_Report';
[~,~,raw] = xlsread(xls_file,2); % segmental (sheet 2)

seq_col = strcmpi(raw(1,:),'ID');

switch lower(seq_id)
    case 'lcx' % in one case it's called cx instead of lcx
        seq_selector = strcmpi(raw(:,seq_col),strcat('lcx',num2str(noise))) | ...
            strcmpi(raw(:,seq_col),strcat('cx',num2str(noise)));
        
    otherwise
        seq_selector = strcmpi(raw(:,seq_col),strcat(seq_id,num2str(noise)));
        
end

% rename view
switch view
    case 'A4C'
        view_tag = '4CH';
    case 'A2C'
        view_tag = '2CH';
    case 'A3C'
        view_tag = 'APLAX';
end

view_col = strcmpi(raw(1,:),'view');
view_selector = strcmpi(raw(:,view_col),view_tag);

segment_col = strcmpi(raw(1,:),'Segment');
segment_selector = strcmpi(raw(:,segment_col),selected_segment);

study_col = strcmpi(raw(1,:),'study_no');
study_val = read_numeric_entry(raw,study_col);

switch layer
    case 'endo'
        tag_lev = 'SLendo';
    case 'mid'
        tag_lev = 'SL';
    case 'epi'
        tag_lev = 'SLepi';
end

switch timing
    case 'ES'
        tag = [tag_lev,'(ES)'];
        
    case 'PeakS'
        tag = [tag_lev,' Peak S'];
        
    case 'PeakG'
        tag = [tag_lev,' Peak G'];
        
    case 'PeakP'
        tag = [tag_lev,' Peak P'];
        
end

layer_col = strcmpi(raw(1,:),tag);
g_strain_val = read_numeric_entry(raw,layer_col);

val = nan(3,1);
for study_no = 1:3
    id_select = seq_selector & ...
        view_selector & ...
        segment_selector & ...
        (study_val == study_no);
    
    if any(id_select)
        val(study_no) =  g_strain_val(id_select);
    else
        val(study_no) = NaN;    
    end
end

end

function val = import_GE_global_strain(seq_id,noise,view,layer)

xls_file = '../AnalysisAssami/GE_2DSTM120_2016_12_13_Report';
[~,~,raw] = xlsread(xls_file,1); % global

seq_col = strcmpi(raw(1,:),'ID');

switch lower(seq_id)
    case 'lcx' % in one case it's called cx instead of lcx
        seq_selector = strcmpi(raw(:,seq_col),strcat('lcx',num2str(noise))) | ...
            strcmpi(raw(:,seq_col),strcat('cx',num2str(noise)));
        
    otherwise
        seq_selector = strcmpi(raw(:,seq_col),strcat(seq_id,num2str(noise)));
        
end

% rename view
switch view
    case 'A4C'
        view_tag = '4CH';
    case 'A2C'
        view_tag = '2CH';
    case 'A3C'
        view_tag = 'APLAX';
end

view_col = strcmpi(raw(1,:),'view');
view_selector = strcmpi(raw(:,view_col),view_tag);

study_col = strcmpi(raw(1,:),'study_no');
study_val = read_numeric_entry(raw,study_col);


layer_col = strcmpi(raw(1,:),strcat('GS',layer,' %'));
g_strain_val = read_numeric_entry(raw,layer_col);

val = nan(3,1);
for study_no = 1:3
    id_select = seq_selector & ...
        view_selector & ...
        (study_val == study_no);
    val(study_no) =  g_strain_val(id_select);
end

end


function val = read_numeric_entry(raw,study_col)

n = size(raw,1);
val = nan(n,1);

for ii = 2:n
    val(ii) = raw{ii,study_col};
end

end