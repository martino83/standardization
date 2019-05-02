function [x_sim,z_sim] = im2sim_space(x_im,z_im,sys,USInfo)

x_im = x_im - USInfo.radius*cos(pi-USInfo.t0); % center
[th_im,r_im] = cart2pol(x_im,z_im); % to polar
th_sim = th_im;
r_sim = r_im + sys.dist_to_probe*1000;
[x_sim,z_sim] = pol2cart(th_sim,r_sim); % leave x centered