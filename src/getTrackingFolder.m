function [displFlist,imagesFlist,pointsFlist,rootFolder] = getTrackingFolder(vendor,view_name)

vendor(strfind(vendor,' ')) = '_';
% -- images
rootfolder = fullfile('D:\CODE_LEUVEN\Standardization2DSTE','tracking',vendor);
s = dir(rootfolder);

for kk = 1:numel(s)
    if s(kk).isdir
        if any(strfind(s(kk).name,view_name))
            read_dir = fullfile(rootfolder,s(kk).name);
        end
    end
end
rootFolder = read_dir;
imagesFlist = getFileList(read_dir,'.mhd');

% -- deformation field
s = dir(read_dir);
for kk = 3:numel(s)
    if s(kk).isdir == 1
        read_dir = fullfile(read_dir,s(kk).name);
    end
end

displFlist = getFileList(read_dir,'.mhd');
pointsFlist = getFileList(read_dir,'.vtk');


end