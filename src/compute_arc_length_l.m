function dl = compute_arc_length_l(X,layer)

xp = permute(X(:,1,:),[1,3,2]);
zp = permute(X(:,3,:),[1,3,2]);
nfiles = size(xp,2);
nlayers = 5;
npoints = size(X,1) / nlayers;
dl = zeros(1,nfiles);

for kk = 0:nfiles-1
    
    xkk = xp(:,kk+1);
    zkk = zp(:,kk+1);
    xkk = reshape(xkk,[npoints,nlayers]);
    zkk = reshape(zkk,[npoints,nlayers]);
    
    switch layer
        case 'endo'
            xkk = xkk(:,1);
            zkk = zkk(:,1);
        case 'mid'
            xkk = xkk(:,3);
            zkk = zkk(:,3);
        case 'epi'
            xkk = xkk(:,5);
            zkk = zkk(:,5);
    end
    
    xkk = xkk(~isnan(xkk));
    zkk = zkk(~isnan(zkk));
    
%     plot(xkk,zkk,'bo'), hold on,
    
    dl(kk+1) = arclength(xkk,zkk,'pchip');
    
end

end