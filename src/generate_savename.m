function [savename,dicom_file] = generate_savename(dicom_folder,view)

s = dir(dicom_folder);
for kk = 3:numel(s)
    
    fname = s(kk).name;
    if strfind(fname,[view '_best'])
        dicom_file = fullfile(dicom_folder,fname);
        info = dicominfo(dicom_file);
        vendor = info.Manufacturer;
        savename = ['templates' filesep vendor filesep view '.srd'];
        savefolder = fileparts(savename);
        [~,~,~] = mkdir(savefolder);
        break
    end
    
end

end

% function vendor = get_vendor_name(dicom_file)
%     id =  strfind(dicom_file,filesep);
%     vendor = dicom_file(id(1)+1:id(2)-1);
% end
%
% function view_name = get_view(dicom_file)
%
% if strfind(dicom_file,'A4C'), view_name = 'A4C'; end
% if strfind(dicom_file,'A2C'), view_name = 'A2C'; end
% if strfind(dicom_file,'A3C'), view_name = 'A3C'; end
%
% end