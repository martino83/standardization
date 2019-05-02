function [em_mesh_points,em_mesh_T,em_ldmk] = load_em_meshes(mask_image,mask_model,...
    f_em_mesh,varargin)

if nargin < 4 || isempty(varargin{1})
    f_aha = ''; else f_aha = varargin{1}; end
if nargin < 5 || isempty(varargin{2})
    n_ldmk_points = 0; else n_ldmk_points = varargin{2}; end
if nargin < 6 || isempty(varargin{3})
    T = compute_transform_between_masks(mask_model,mask_image,'affine',0); else T = varargin{3}; end
if nargin < 7 || isempty(varargin{4})
    R_reg = []; else R_reg = varargin{4}; end
if nargin < 8 || isempty(varargin{5})
    mask_reg = []; else mask_reg = varargin{5}; end


%-- apply to em mesh
load(f_em_mesh);
npoints = size(X,1);
nframesSimu = size(X,3);
x_mesh_tot = X(:,1,:);
y_mesh_tot = X(:,2,:);
z_mesh_tot = X(:,3,:);

% -- apply affine part
Ta = compute_transform_between_masks(mask_model,mask_image,'affine',0);
[X_matched] = apply_transform_to_mesh([x_mesh_tot(:),y_mesh_tot(:),z_mesh_tot(:)],mask_model,Ta);

em_mesh_points = reshape(X_matched,[npoints,nframesSimu,3]); % em meshes 4 scatterers
em_mesh_points = permute(em_mesh_points,[1 3 2]);

X0 = X(:,:,1);

% -- non-rigid part
X0_nr = apply_transform_to_mesh(X0,mask_model,T,'non-rigid',mask_reg,R_reg);
dX = X0_nr - em_mesh_points(:,:,1);
dX = repmat(dX,[1,1,size(em_mesh_points,3)]);
em_mesh_points = em_mesh_points + dX;

%-- mesh series for scatter propagation
% em_mesh_points = reshape(X_matched,[npoints,nframesSimu,3]); % em meshes 4 scatterers
% em_mesh_points = permute(em_mesh_points,[1 3 2]);

% close all
% figure
% for ii = 1:60
%     plotmesh(em_mesh_points(:,:,ii),Tri); hold on;
%     plotmesh(X(:,:,ii),Tri); hold off
%     pause(.05)
% end

%-- aha triangulation
if ~isempty(f_aha)
    mesh_aha = read_vtkMesh_martino(f_aha);
    
    if any(strcmp({mesh_aha.attributes.name},'aha'))
        aha = mesh_aha.attributes(mesh_aha.find_attribute('aha')).attribute_array;
        id_aha = aha<19;
    end
    
    if any(strcmp({mesh_aha.attributes.name},'zones'))
        aha = mesh_aha.attributes(mesh_aha.find_attribute('zones')).attribute_array;
        id_aha = aha<17;
    end
else
    id_aha = 1:size(Tri,1);
end

em_mesh_T = Tri(id_aha,:);

[em_mesh_T,idx] = remove_unconnected_nodes(em_mesh_T);
em_mesh_points = em_mesh_points(idx,:,:);
% plotmesh(em_mesh_points(:,:,1),em_mesh_T)
% landmarks

% -- landmarks
O = extract_mesh_boundaries(em_mesh_T);
idx = unique(O(:));
em_ldmk = em_mesh_points(idx,:,:);

% plot3(em_ldmk(:,1,1),em_ldmk(:,2,1),em_ldmk(:,3,1),'b.')

% -- subsample if needed
if n_ldmk_points > 0
    
    n_points = size(em_ldmk,1);
    id_keep = randperm(n_points,n_ldmk_points);
    em_ldmk = em_ldmk(id_keep,:,:);
    
end










