function status = export_dicom(mat_file,savename)

%--
raw_dir = fullfile('D:\DATA\Standardization\raw_data_from_vendors');

% -- get vendor
f = fileparts(mat_file);
f = fileparts(f);
[f,view_type] = fileparts(f);
[f,vendor] = fileparts(f);

% --
a = fileparts(savename);
[~,~,~] = mkdir(a);
load(mat_file);

% -- template for dicom
load(fullfile('templates',vendor,[view_type '.new.srd']),'-mat');

switch vendor
    case 'ESAOTE'
        fname = ['D:\DATA\Standardization\raw_data_from_vendors\ESAOTE\' view_type '_best'];
    case 'Philips Medical Systems'
        fname = ['D:\DATA\Standardization\raw_data_from_vendors\Philips Medical Systems\' view_type '_best.txt'];
    case 'SAMSUNG MEDISON CO'
        fname = ['D:\DATA\Standardization\raw_data_from_vendors\SAMSUNG MEDISON CO.,LTD\' view_type '_best'];
    case 'Hitachi Aloka Medical,Ltd'
        fname = ls(['D:\DATA\Standardization\raw_data_from_vendors\Hitachi Aloka Medical,Ltd\old\*' view_type '_best']);
        fname = fullfile('D:\DATA\Standardization\raw_data_from_vendors\Hitachi Aloka Medical,Ltd\old',fname);
    case 'GE Vingmed Ultrasound'
        % just for testing. They don't provide remplate dicoms
        fname = ['D:\DATA\Standardization\raw_data_from_vendors\SAMSUNG MEDISON CO.,LTD\' view_type '_best'];
    case 'Siemens'
        fname = ['D:\DATA\Standardization\raw_data_from_vendors\SIEMENS\' view_type '_best'];
    otherwise
        [f,n] = fileparts(USInfo.dicom_file);
        fname = fullfile(raw_dir,vendor,n);
end




if strcmp(vendor,'Siemens')
    dicomdict('set','D:\CODE_LEUVEN\Standardization2DSTE\dicom-dict-Siemens.txt');
else
    dicomdict('factory');
end

info = dicominfo(fname);

% -- add vendor specific fields
IM = im_sim;

switch vendor
    case 'ESAOTE'
        
        
        mode = 1;
        switch mode
            case 1
                % 1/ resample images
                dummy = zeros(600,860,size(IM,3));
                x = 0:USInfo.pixelsize(2):(USInfo.gridsize(2)-1)*USInfo.pixelsize(2);
                y = 0:USInfo.pixelsize(1):(USInfo.gridsize(1)-1)*USInfo.pixelsize(1);
                xi = linspace(0,(USInfo.gridsize(2)-1)*USInfo.pixelsize(2),860);
                yi = linspace(0,(USInfo.gridsize(1)-1)*USInfo.pixelsize(1),600);
                USInfo.pixelsize = [xi(2)-xi(1),yi(2)-yi(1)];
                
                [x,y] = meshgrid(x,y);
                [xi,yi] = meshgrid(xi,yi);
                for ii = 1:size(IM,3)
                    dummy(:,:,ii) = interp2(x,y,double(IM(:,:,ii)),xi,yi,'cubic',0);
                end
                IM = dummy;
                % adjust pixel size accordingly
                
                
                %         USInfo.pixelsize = USInfo.pixelsize([2,1]);
                % 2/ Change UID
                info.SeriesInstanceUID = dicomuid;
                info.SOPInstanceUID = dicomuid;
                info.StudyInstanceUID = dicomuid;
                nframes = size(IM,3);
                info.FrameNumbersOfInterest = [0,nframes-1]';
                str = [];
                str1 = [];
                for ii = 1:numel(info.FrameNumbersOfInterest)
                    str = strcat(str,['R Wave number ',num2str(ii),'\']);
                    str1 = strcat(str1,'RWAVE\');
                end
                info.FrameOfInterestDescription = str(1:end-1);
                info.FrameOfInterestType = str1(1:end-1);
                info.HeartRate = 60;
                
        end
        
        [a,b] = fileparts(savename);
        info.PatientName = ['FamilyName: ','''',b,''''];
        info.PatientName = b;
        % first 6 fields seem to be constant for ESAOTE
        %         1.3.76.2.3.3.364583393.210.1.23.1.20130424121517796
        %         1.3.76.2.3.3.364583393.210.20130424120017875
        %         1.3.76.2.3.3.364583393.210.1.20130424120040796
        
end

IM = cat(4,IM,IM,IM);
IM = uint8(permute(IM,[1 2 4 3]));
nfiles = size(IM,4);

% info.Width = size(IM,2);
info.SOPClassUID = '1.2.840.10008.5.1.4.1.1.3.1';

% info.Height = size(IM,1);
info.StartTrim = 0;
info.StopTrim = nfiles;
info.CineRate = nfiles;
% info.Rows = size(IM,1);
% info.Columns = size(IM,2);
% info.Manufacturer = '';
% info.ManufacturerModelName = '';
% info.SequenceOfUltrasoundRegions.Item_1.RegionDataType = 1;
% info.SequenceOfUltrasoundRegions.Item_1.RegionFlags = 2;
info.SequenceOfUltrasoundRegions.Item_1.RegionLocationMinX0 = 0;
info.SequenceOfUltrasoundRegions.Item_1.RegionLocationMinY0 = 0;
info.SequenceOfUltrasoundRegions.Item_1.RegionLocationMaxX1 = size(IM,2)-1;
info.SequenceOfUltrasoundRegions.Item_1.RegionLocationMaxY1 = size(IM,1)-1;
info.SequenceOfUltrasoundRegions.Item_1.ReferencePixelX0 = 0;
info.SequenceOfUltrasoundRegions.Item_1.ReferencePixelY0 = 0;
% info.SequenceOfUltrasoundRegions.Item_1.PhysicalUnitsXDirection = 3;
% info.SequenceOfUltrasoundRegions.Item_1.PhysicalUnitsYDirection = 3;
% info.SequenceOfUltrasoundRegions.Item_1.ReferencePixelPhysicalValueX = 0;
% info.SequenceOfUltrasoundRegions.Item_1.ReferencePixelPhysicalValueY = 0;
info.SequenceOfUltrasoundRegions.Item_1.PhysicalDeltaX = USInfo.pixelsize(1)/10;
info.SequenceOfUltrasoundRegions.Item_1.PhysicalDeltaY = USInfo.pixelsize(2)/10;
info.MediaStorageSOPInstanceUID = '1.3.12.2.1107.5.5.10.401762.30000015042409223212300000103';
info.ImplementationClassUID = '1.3.12.2.1107.5.99.3.20080101';
info.SOPInstanceUID = '1.3.12.2.1107.5.5.10.401762.30000015042409223212300000103';
info.CreateMode = 'Copy';

% 'UseMetadataBitDepths',true,'VR','explicit','WritePrivate',true

%%
% TS = '1.2.840.10008.1.2';
% TS = '1.2.840.10008.1.2.1';
% TS = '1.2.840.10008.1.2.1.99';
% TS = '1.2.840.10008.1.2.2';
% TS = '1.2.840.10008.1.2.5';
% TS = '1.2.840.10008.1.2.4.50';
% TS = '1.2.840.10008.1.2.4.51';
% TS = '1.2.840.10008.1.2.4.70';
% TS = '1.2.840.10008.1.2.4.90';
% TS = '1.2.840.10008.1.2.4.91';
% TS = '1.2.840.10008.1.2.4.100';
% TS = '1.2.840.10008.1.2.2';
% TS = '1.2.840.10008.1.2.4.50';
% status = dicomwrite(IM,savename,info,'CreateMode','Copy','TransferSyntax',TS,'VR','explicit');
status = dicomwrite(IM,savename,info,'CreateMode','Copy');
% dicomdisp(savename)


debug();