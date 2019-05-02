function scatt_points_fg = propagate_fg_points(t,BC,em_mesh_points,em_mesh_T)

nFrames = size(em_mesh_points,3);

parfor ii = 1:nFrames
    
    TR = triangulation(em_mesh_T,em_mesh_points(:,:,ii));
    PC = barycentricToCartesian(TR,t,BC);
    scatt_points_fg{ii}.x = PC(:,1);
    scatt_points_fg{ii}.y = PC(:,2);
    scatt_points_fg{ii}.z = PC(:,3);
    
end