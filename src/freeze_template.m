function im_freeze = freeze_template(x,y,im_templ,mask_sector,im_ldmk)

nframes = size(im_templ,3);
im_ldmk0 = im_ldmk(:,:,1);
im_freeze = zeros(size(im_templ));

% -- pixel domain
[J,I] = meshgrid(1:size(im_templ,2),1:size(im_templ,1));
isin = mask_sector == 1;
J = J(isin);
I = I(isin);
id = sub2ind([size(im_templ,1),size(im_templ,2)],I,J);

% -- image domain
[X,Y] = meshgrid(x,y);
Xi = X(isin);
Yi = Y(isin);
points = [Xi(:),Yi(:)]';

for kk = 1:nframes
    
    disp([num2str(kk) '/' num2str(nframes)])
    imkk = im_templ(:,:,kk);
    im_freeze_kk = zeros(size(imkk));
    
    % -- warping transform
    st = tpaps(im_ldmk0',im_ldmk(:,:,kk)',1);
    XYw = fnval(st,points);
    
    % -- interp amplitudes
    amp = interp2(x,y,imkk,XYw(1,:),XYw(2,:),'cubic',0);
    im_freeze_kk(id) = amp;
    im_freeze(:,:,kk) = im_freeze_kk;
    
end

    




