function mask_sector = compute_mask_sector(USInfo)

[x,z] = meshgrid(USInfo.x,USInfo.z);
x = x - USInfo.radius*cos(pi-USInfo.t0);

[t,r] = cart2pol(x,z); % to polar

r0 = 0;
rf = USInfo.radius;
th0 = USInfo.tf;
thf = USInfo.t0;
mask_sector = t < thf & t > th0 & r > r0 & r < rf;

% [x_edge,y_edge] = pol2cart(t(isedge),r(isedge));
% z_edge = zeros(size(x_edge));
% 
% if nz > 1
%     n_edges = numel(y_edge);
%     z_edge = (linspace(-nz/2,nz/2,nz)' * ones(1,n_edges) )';
%     z_edge = z_edge(:);
%     
%     x_edge = repmat(x_edge,[nz 1]);
%     y_edge = repmat(y_edge,[nz 1]);
% end
% 
% edge = [x_edge(:),z_edge(:),y_edge(:)];
% edge_2d = [x_edge(:),y_edge(:)];
% 
% edge_2d = unique(edge_2d,'rows');
% edge = unique(edge,'rows');
% 
% % x_edge =  edge(:,1);
% % y_edge =  edge(:,2);
% % z_edge =  edge(:,3);
% 
% edge(:,1) = edge(:,1) + rf*cos(pi-thf);
% edge(:,2) = edge(:,2) / 1.5 * USInfo.elev/2;
% edge_2d(:,1) = edge_2d(:,1) + rf*cos(pi-thf);
