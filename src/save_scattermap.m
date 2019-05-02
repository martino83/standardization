function save_scattermap(scatt_points_fg,scatt_points_bg,...
    ampl_fg_cell,ampl_bg_cell,sys,USInfo,save_dir)

nframes = numel(scatt_points_fg);
max_amp = max(abs([ampl_fg_cell{1}(:);ampl_bg_cell{1}(:)]));

for jj = 1:nframes

    nfg = numel(scatt_points_fg{jj}.x(:));
    x_im = [scatt_points_fg{jj}.x(:);scatt_points_bg{jj}.x(:)];
    y_im = [scatt_points_fg{jj}.y(:);scatt_points_bg{jj}.y(:)];
    z_im = [scatt_points_fg{jj}.z(:);scatt_points_bg{jj}.z(:)];
    ampl = 1e6*([ampl_fg_cell{jj}(:);ampl_bg_cell{jj}(:)] ./ max_amp);
    
    % -- go to sim space
    [x_sim,z_sim] = im2sim_space(x_im,z_im,sys,USInfo);
    y_sim = y_im;
    
    % -- cole coordinate notation (x - axial)
    scat_x = single(z_sim);
    scat_y = single(x_sim);
    scat_z = single(y_sim);
    
    scat_x_fg = scat_x(1:nfg);
    scat_y_fg = scat_y(1:nfg);
    scat_z_fg = scat_z(1:nfg);
    
    scat_x_bg = scat_x(nfg+1:end);
    scat_y_bg = scat_y(nfg+1:end);
    scat_z_bg = scat_z(nfg+1:end);
    
    % --
    ampl_fg = single(ampl(1:nfg));
    ampl_bg = single(ampl(nfg+1:end));
    
    savename = [save_dir '/frame_' num2str(jj) '.mat'];
    
    varvalue = {scat_x_fg,scat_x_bg,scat_y_fg,scat_y_bg,scat_z_fg,scat_z_bg,...
        ampl_fg,ampl_bg};
    varname = {'scat_x_fg','scat_x_bg','scat_y_fg','scat_y_bg','scat_z_fg','scat_z_bg',...
        'ampl_fg','ampl_bg'};
    iSaveX(savename,varvalue,varname)
    disp(savename);
    
end