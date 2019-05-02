function [t_cont,t_floor,w,t_ceil] = temporal_matching(t_em_ldmk,t_im_ldmk)

t_sys = (t_em_ldmk(1):t_em_ldmk(2)) / t_em_ldmk(2) * t_im_ldmk(2);
t_dia = ((t_em_ldmk(2):t_em_ldmk(3)) - t_em_ldmk(2)) / (t_em_ldmk(3)-t_em_ldmk(2)) * (t_im_ldmk(3)-t_im_ldmk(2)) + t_im_ldmk(2);
t_cont = [t_sys,t_dia(2:end)];
t_floor = floor(t_cont);
t_ceil = ceil(t_cont);
w = (t_cont - t_floor); 

end


