function [moving_reg, Xx, Xy] = non_rigid_refine(moving_reg, fixed)

% -- mirt
main.similarity='ssd';  % similarity measure, e.g. SSD, CC, SAD, RC, CD2, MS, MI
main.subdivide=2;       % use 3 hierarchical levels
main.okno= 16;            % mesh window size
main.lambda = 0.05;    % transformation regularization weight, 0 for none
main.single=1;          % show mesh transformation at every iteration

% Optimization settings
optim.maxsteps = 100;   % maximum number of iterations at each hierarchical level
optim.fundif = 1e-5;    % tolerance (stopping criterion)
optim.gamma = 1;       % initial optimization step size
optim.anneal= 0.8;       % annealing rate on the optimization step

h = fspecial('gauss',[5 5],2);
refim = imfilter(moving_reg,h); refim = refim / max(refim(:));
im = imfilter(fixed,h); im = im / max(im(:));

mask = refim + im > 0;
se = strel('ball',10,10);
mask = imdilate(double(mask),se);
mask = mask - min(mask(:)) > .1;
im(mask == 0) = NaN;
if main.single==1, figure; end
[res,moving_reg] = mirt2D_register(refim,im, main, optim);

% Precompute the matrix B-spline basis functions
F = mirt2D_F(res.okno);

% obtaine the position of all image voxels (Xx,Xy) from the positions
% of B-spline control points (res.X)
[Xx,Xy] = mirt2D_nodes2grid(res.X, F, res.okno);