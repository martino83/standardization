function [X,Tri] = read_mesh_folder(rep)

flistIn = getFileList(rep,'.vtk');
nfiles = size(flistIn,1);

% initialize
mesh = read_vtkMesh_martino(flistIn(1,:));
X = zeros(mesh.npoints,3,nfiles);
X(:,:,1) = mesh.points;
Tri = mesh.triangles;
parfor ii = 2:nfiles
    
    mesh = read_vtkMesh_martino(flistIn(ii,:));
    X(:,:,ii) = mesh.points;
    
    
end

end

function flistIn = getFileList(pathstr,varargin)

if nargin < 2 || isempty(varargin{1})
    format = '.mhd'; else format = varargin{1}; end

% [pathstr,root] = fileparts(InPrefix);

flist = ls(pathstr);
flist = flist(3:end,:);
nfiles = size(flist,1);

cont = 0;
% order = [];
% flistIn = [];

for ii = 1:nfiles
    
    fname = flist(ii,:);
    [~,~,ext] = fileparts(fname);
    
    if strncmp(ext,format,4)
        cont = cont + 1;
        %         in1 = numel(root)+1;
        %         in2 = strfind(fname,ext)-1;
        
        frame_id = fname(isstrprop(fname,'digit'));
        
        ordering(cont) = str2double(frame_id);
        flistIn(cont,:) = fullfile(pathstr,fname);
    end
end

[~,id] = sort(ordering);
flistIn = flistIn(id,:);

end