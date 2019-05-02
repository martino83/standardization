function t_im_ldmk_out = compute_im_ldmk(t_im_ldmk_in,frames)

t_im_ldmk_out(1) = 0;
t_im_ldmk_out(3) = numel(frames)-1;
t_im_ldmk_out(2) = round((t_im_ldmk_in(2) - t_im_ldmk_in(1)) / (t_im_ldmk_in(3) - t_im_ldmk_in(1)) * (numel(frames)-1));