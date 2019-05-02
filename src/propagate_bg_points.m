function scatt_points_bg = propagate_bg_points(x_bg,y_bg,z_bg,tps_em_fwd,em_ldmk)

nFrames = numel(tps_em_fwd);

X_eval = [x_bg(:),y_bg(:),z_bg(:)];
em_ldmk0 = em_ldmk(:,:,1);

parfor ii = 1:nFrames
    
    disp([num2str(ii) '/' num2str(nFrames)]);
    X_bg_kk = eval_st(em_ldmk0',tps_em_fwd{ii},X_eval');
    scatt_points_bg{ii}.x = X_bg_kk(1,:)';
    scatt_points_bg{ii}.y = X_bg_kk(2,:)';
    scatt_points_bg{ii}.z = X_bg_kk(3,:)';
                
end