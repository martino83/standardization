function import_vendor_output(vendor,seq_id,noise,view,savedir)

savename = strcat('export_',vendor,'_',seq_id,'_',view,'_noise',num2str(noise),'.mat');
savename = fullfile(savedir,savename);


if ~exist(savename,'file')
    disp(['creating ',savename]);
    strain_struct.info.vendor = vendor;
    strain_struct.info.seq_id = seq_id;
    strain_struct.info.view = view;
    strain_struct.info.noise_level = noise;
    
    switch view
        case 'A4C'
            strain_struct.segments = {'global',...
                'basSept',...
                'midSept',...
                'apSept',...
                'apLat',...
                'midLat',...
                'basLat'};
            
        case 'A2C'
            strain_struct.segments = {'global',...
                'basInf',...
                'midInf',...
                'apInf',...
                'apAnt',...
                'midAnt',...
                'basAnt'};
            
        case 'A3C'
            strain_struct.segments = {'global',...
                'basPost',...
                'midPost',...
                'apPost',...
                'apAntSept',...
                'midAntSept',...
                'basAntSept'};
            
    end
    
    switch vendor
        case 'GE'
            strain_data = import_GE_output(seq_id,noise,view);
            
        otherwise
            error('undefined vendor')
    end
    
    save(savename,'strain_struct');
    
else
    disp([savename,' exists already']);
end
end

function data = import_GE_output(seq_id,noise,view)


xls_file = '../AnalysisAssami/GE_2DSTM120_2016_12_13_Report';
[~,~,raw] = xlsread(xls_file,1); % global

%%% GLOBAL STRAIN
seq_col = strcmpi(raw(1,:),'ID');

switch lower(seq_id)
    case 'lcx' % in one case it's called cx instead of lcx
        seq_selector = strcmpi(raw(:,seq_col),strcat('lcx',num2str(noise))) | ...
            strcmpi(raw(:,seq_col),strcat('cx',num2str(noise)));
        
    otherwise
        seq_selector = strcmpi(raw(:,seq_col),strcat(seq_id,num2str(noise)));
        
end

% select sequence



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


for layer = {'endo','mid','epi'}
    layer_col = strcmpi(raw(1,:),strcat('GS',layer,' %'));
    g_strain_val = read_numeric_entry(raw,layer_col);
    
    for study_no = 1:3
        id_select = seq_selector & ...
            view_selector & ...
            (study_val == study_no);
        cmd = ['data.global.',layer{1},'(study_no,1) =  g_strain_val(id_select);'];
        eval(cmd)
    end
end

% read

end


function val = read_numeric_entry(raw,study_col)

n = size(raw,1);
val = nan(n,1);

for ii = 2:n
    val(ii) = raw{ii,study_col};
end

end