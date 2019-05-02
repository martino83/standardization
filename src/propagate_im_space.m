function scatt_prop = propagate_im_space(x_scatt,z_scatt,tps_im_fwd)

nframes = numel(tps_im_fwd);
X_eval = [x_scatt(:),z_scatt(:)]';

parfor ii = 1:nframes
    xz_scatt = fnval(tps_im_fwd{ii},X_eval); % values for amplitude
    scatt_prop{ii}.x = xz_scatt(1,:)';
    scatt_prop{ii}.z = xz_scatt(2,:)';
end