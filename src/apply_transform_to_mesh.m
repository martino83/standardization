function [X_matched,X_slice] = apply_transform_to_mesh(X_in,mask_model,T,varargin)

if nargin < 4 || isempty(varargin{1})
    transform_type = 'affine'; else transform_type = varargin{1}; end
if nargin < 5 || isempty(varargin{2})
    moving_reg = []; else moving_reg = varargin{2}; end
if nargin < 6 || isempty(varargin{3})
    R_reg = []; else R_reg = varargin{3}; end

% mask model contains the transform to slice the 3D mesh.
% T contains the 2d transform to align the 2 slices (the model and the image)
x_mesh = X_in(:,1);
y_mesh = X_in(:,2);
z_mesh = X_in(:,3);

% align model on slice
[x_mesh_rot,y_mesh_rot,z_mesh_rot] = rotate3D_data(x_mesh-mask_model.orig(1),y_mesh-mask_model.orig(2),z_mesh-mask_model.orig(3),...
    - mask_model.theta(1),- mask_model.theta(2),- mask_model.theta(3));
x_mesh_rot = x_mesh_rot + mask_model.orig(1);
z_mesh_rot = z_mesh_rot + mask_model.orig(3);
X_slice = [x_mesh_rot,y_mesh_rot,z_mesh_rot];

% align slices
xtmp = x_mesh_rot;
ztmp = z_mesh_rot;


switch transform_type
    
    case 'rigid_new'
        [xtmp,ztmp] = transformPointsForward(T{1},xtmp,ztmp); % affine part
        
        
    case {'affine','rigid'}
        [xtmp,ztmp] = transformPointsForward(T{1},xtmp,ztmp); % affine part
        if numel(T)==2
            [xtmp,ztmp] = transformPointsForward(T{2},xtmp,ztmp);
        end
        
    case 'non-rigid'
        %/ 
        [xtmp,ztmp] = transformPointsForward(T{1},xtmp,ztmp); % affine part + translation
        [xtmp,ztmp] = transformPointsForward(T{2},xtmp,ztmp);
        
        %/ non rigid part
        xm = linspace(R_reg.XWorldLimits(1),R_reg.XWorldLimits(2),R_reg.ImageSize(2));
        ym = linspace(R_reg.YWorldLimits(1),R_reg.YWorldLimits(2),R_reg.ImageSize(1));
        [Ym,Xm] = ndgrid(ym,xm);
        
%         imagesc(xm,ym,moving_reg); hold on,
%         plot(xtmp,ztmp,'r.')
        
        [X,Y] = meshgrid(1:size(mask_model.mask,2),1:size(mask_model.mask,1));
        dX = X - T{3}.gX;
        dY = Y - T{3}.gY;
        dXm = dX * R_reg.PixelExtentInWorldX;
        dYm = dY * R_reg.PixelExtentInWorldY;
        
        dx_node = interp2(Xm,Ym,dXm,xtmp,ztmp,'cubic',0);
        dy_node = interp2(Xm,Ym,dYm,xtmp,ztmp,'cubic',0);
        
        xtmp = xtmp + dx_node;
        ztmp = ztmp + dy_node;
                
%         plot(xtmp,ztmp,'g.')
        
end
% xy1 = [x_mesh_rot,z_mesh_rot,ones(size(x_mesh_rot))] * T;
x_mesh_matched = xtmp;
z_mesh_matched = ztmp;
clear xtmp ztmps

if numel(T)==1
    y_mesh_matched = det(T{1}.T(1:2,1:2))*y_mesh_rot;
end

if numel(T)==3
    y_mesh_matched = det(T{2}.T(1:2,1:2))*y_mesh_rot;
end

if numel(T)==2
    y_mesh_matched = det(T{1}.T(1:2,1:2))*y_mesh_rot;
end

% y_mesh_matched = y_mesh_rot;
X_matched = [x_mesh_matched,y_mesh_matched,z_mesh_matched];