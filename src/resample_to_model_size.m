function [maski,xi,yi] = resample_to_model_size(mask_model,mask_image)

% -- resameple the image mask in the same space of the model mask

[y_im,x_im] = ndgrid(mask_image.y,mask_image.x);
F_mask = griddedInterpolant(y_im,x_im,double(mask_image.mask > 0),'nearest');

yp = y_im(mask_image.mask == 1);
xp = x_im(mask_image.mask == 1);
xc = mean(xp(:));
yc = mean(yp(:));

dx = max(mask_model.x(:)) - min(mask_model.x(:)); dx = dx + dx/10;
dy = max(mask_model.y(:)) - min(mask_model.y(:)); dy = dy + dy/10;
xi = linspace(xc - dx/2,xc + dx/2,size(mask_model.mask,2));
yi = linspace(yc - dy/2,yc + dy/2,size(mask_model.mask,1));
[Yi,Xi] = ndgrid(yi,xi);
maski = F_mask(Yi,Xi); % -- resampled mask