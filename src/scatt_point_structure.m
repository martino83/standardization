function [scatt_points_fg,scatt_points_bg] = scatt_point_structure(x_im,y_im,z_im,savename_BC)

s = what(savename_BC);
s = s.mat;
nfiles = numel(s);

scatt_points_fg = cell(1,nfiles);
scatt_points_bg = cell(1,nfiles);

for kk = 1:nfiles
    
    disp([num2str(kk) '\' num2str(nfiles)])
    
    
    x_im_k = x_im(:,kk);
    y_im_k = y_im(:,kk);
    z_im_k = z_im(:,kk);
    
    fname = ['frame' num2str(kk) '.mat'];
    t = iLoadX(fullfile(savename_BC,fname),'t');
    
    
%     isfg = ~isnan(t);
%     isin = abs(y_im(:,kk)) < 5;
%     plot(x_im(isin & isfg,kk),z_im(isin & isfg,kk),'r.'), hold on,
%     plot(x_im(isin & ~isfg,kk),z_im(isin & ~isfg,kk),'b.'),
%     hold off,
%     axis image
    
    is_fg = ~isnan(t);
    is_bg = ~is_fg;
    
    x_fg = x_im_k(is_fg);
    y_fg = y_im_k(is_fg);
    z_fg = z_im_k(is_fg);
    
    x_bg = x_im_k(is_bg);
    y_bg = y_im_k(is_bg);
    z_bg = z_im_k(is_bg);
    
    scatt_points_fg{kk}.x = x_fg;
    scatt_points_fg{kk}.y = y_fg;
    scatt_points_fg{kk}.z = z_fg;
    
    scatt_points_bg{kk}.x = x_bg;
    scatt_points_bg{kk}.y = y_bg;
    scatt_points_bg{kk}.z = z_bg;
    
end