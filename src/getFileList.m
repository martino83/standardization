function flistIn = getFileList(pathstr,varargin)

if nargin < 2 || isempty(varargin{1})
    format = '.mhd'; else format = varargin{1}; end

% [pathstr,root] = fileparts(InPrefix);

flist = ls(pathstr);
flist = flist(3:end,:);
nfiles = size(flist,1);

cont = 0;
ordering = [];
flistIn = '';

for ii = 1:nfiles
    
    fname = flist(ii,:);
    [~,~,ext] = fileparts(fname);
    
    if strncmp(ext,format,4)
        cont = cont + 1;
%         in1 = numel(root)+1;
%         in2 = strfind(fname,ext)-1;

        id = find(isstrprop(fname,'digit'));
        % -- if not consecutive then keep the last. Might be some numbers
        % do not refer to the time index, e.g. A4C
        id_keep = [diff(id)==1,1];
        id = id(id_keep == 1);
        frame_id = fname(id);
        
        ordering(cont) = str2double(frame_id);
        flistIn(cont,:) = fullfile(pathstr,fname);
    end
end

if ~isempty(ordering)
    [~,id] = sort(ordering);
    flistIn = flistIn(id,:);
end