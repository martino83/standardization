function [t,BC] = compute_baricentric_coordinates(x_im,y_im,z_im,em_mesh_points,em_mesh_T,mask,mask_sector)

mask_sector3D = repmat(mask_sector,[1 1 size(mask,1)]);
mask_sector3D = permute(mask_sector3D,[3 2 1]);

y = linspace(-USInfo.elev/2,USInfo.elev/2,20);
x = USInfo.x;
z = USInfo.z;

%/ at first select scatterers in the mask AND in the scan area
isfg = interp3(x,y,z,mask,x_im,y_im,z_im,'nearest',0);

%/ refine with baricebtric coordinates
TR = triangulation(em_mesh_T,em_mesh_points);
[t,BC] = pointLocation(TR,[x_im(isfg(:)),y_im(isfg(:)),z_im(isfg(:))]);
        

%/ some scatteres on the boundary might not be assigned. They will be
% attributed to the background
isin_mesh = ~ isnan(t);

% scatterers belonging to the binary mask but not selected by tsearchn.
% Some of then will be outside the scan are
x_tmp = xkk_im_fg(~isin_mesh);
y_tmp = ykk_im_fg(~isin_mesh);
z_tmp = zkk_im_fg(~isin_mesh);

xkk_im_bg = [xkk_im_bg;x_tmp];
ykk_im_bg = [ykk_im_bg;y_tmp];
zkk_im_bg = [zkk_im_bg;z_tmp];

x_tmp = xkk_sim_fg(~isin_mesh);
y_tmp = ykk_sim_fg(~isin_mesh);
z_tmp = zkk_sim_fg(~isin_mesh);

xkk_sim_bg = [xkk_sim_bg;x_tmp];
ykk_sim_bg = [ykk_sim_bg;y_tmp];
zkk_sim_bg = [zkk_sim_bg;z_tmp];


%         % sim 2 im transform (need later)
%         [th_sim_bg,r_sim_bg] = cart2pol(ykk_sim_bg,zkk_sim_bg);
%         th_im_bg = th_sim_bg;
%         r_im_bg = r_sim_bg - sys.dist_to_probe*1000;
%         [ykk_im_bg,zkk_im_bg] = pol2cart(th_im_bg,r_im_bg);
%         ykk_im_bg = ykk_im_bg + width/2;
%         xkk_im_bg = xkk_sim_bg;


% isinscan = interp2(y,z,mask_sector,ykk_bg,zkk_bg,'nearest',0);
% xkk_bg = xkk_bg(isinscan);
% ykk_bg = ykk_bg(isinscan);
% zkk_bg = zkk_bg(isinscan);

xkk_im_fg = xkk_im_fg(isin_mesh);
ykk_im_fg = ykk_im_fg(isin_mesh);
zkk_im_fg = zkk_im_fg(isin_mesh);

xkk_sim_fg = xkk_sim_fg(isin_mesh);
ykk_sim_fg = ykk_sim_fg(isin_mesh);
zkk_sim_fg = zkk_sim_fg(isin_mesh);
ampl_fg = ampl_fg(isin_mesh);

% figure
% slice(x,y,z,double(mask),mean(x(:)),mean(y(:)),mean(z(:))), shading flat, hold on,
% plot3(xkk_fg,ykk_fg,zkk_fg,'g.')
% plot3(x_tmp,y_tmp,z_tmp,'ro')
% axis image
% drawnow
% hold off

%/ assign amplitude
ampl_bg = assign_amplitude_2D(y,z,im,ykk_im_bg,zkk_im_bg,'dec');
n_fg = numel(ampl_fg);
n_bg = numel(ampl_bg);
