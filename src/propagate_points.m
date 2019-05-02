function [x_prop,z_prop] = propagate_points(displFlist,x,y,x0,z0)

x0 = x0(:);
z0 = z0(:);

nPoints = numel(x0);
nFrames = size(displFlist,1);
x_prop = zeros(nPoints,nFrames+1);
z_prop = zeros(nPoints,nFrames+1);

x_prop(:,1) = x0;
z_prop(:,1) = z0;

for jj = 1:nFrames
    filename = displFlist(jj,:);
    displ = read_mhd(filename); % images
    
    x_prop(:,jj+1) = x_prop(:,jj) + interp2(x,y,displ.datay,x_prop(:,jj),z_prop(:,jj),'cubic',0);
    z_prop(:,jj+1) = z_prop(:,jj) + interp2(x,y,displ.datax,x_prop(:,jj),z_prop(:,jj),'cubic',0);
end
