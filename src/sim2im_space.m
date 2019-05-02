function [xkk_im,ykk_im,zkk_im] = sim2im_space(xkk_sim,ykk_sim,zkk_sim,sys,USInfo)

[th_sim,r_sim] = cart2pol(xkk_sim,zkk_sim); % to polar
th_im = th_sim;

r_im = r_sim - sys.dist_to_probe*1000;
[xkk_im,zkk_im] = pol2cart(th_im,r_im);
xkk_im = xkk_im + USInfo.radius*cos(pi-USInfo.t0);
ykk_im = ykk_sim;