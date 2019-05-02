function [im_templ,mask,USInfo,frames] = load_templates(srd_fname)

load(srd_fname,'-mat');

% select tracked frames
[tmp,view_name] = fileparts(srd_fname);

if contains(view_name,'A4C')
    view_name = 'A4C';
end

if contains(view_name,'A3C')
    view_name = 'A3C';
end

if contains(view_name,'A2C')
    view_name = 'A2C';
end

[~,vendor] = fileparts(tmp);

[~,~,~,rootDir] = getTrackingFolder(vendor,view_name);
load([rootDir '/frames.mat']);
% frames = USInfo.ED1:USInfo.ED2;

im_templ = USData.tissue(:,:,frames);
width = USInfo.pixelsize(2)*USInfo.gridsize(2);
radius = USInfo.pixelsize(1)*USInfo.gridsize(1);

mask.mask = USData.mask;
mask.x = linspace(0,width,USInfo.gridsize(2)); % lateral
mask.y = linspace(0,radius,USInfo.gridsize(1)); % axial

USInfo.width = width;
USInfo.radius = radius;
USInfo.elev = 70;
USInfo.x = mask.x;
USInfo.z = mask.y;
