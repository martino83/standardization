
function dr = compute_arc_length_r(X)

xp = permute(X(:,1,:),[1,3,2]);
zp = permute(X(:,3,:),[1,3,2]);
nfiles = size(xp,2);
nlayers = 5;
npoints = size(X,1) / nlayers;
dr = zeros(npoints,nfiles);

for kk = 0:nfiles-1
    
    xkk = xp(:,kk+1);
    zkk = zp(:,kk+1);
    xkk = reshape(xkk,[npoints,nlayers]);
    zkk = reshape(zkk,[npoints,nlayers]);
    
    tmp = cumsum(sqrt(diff(xkk,[],2).^2 + diff(zkk,[],2).^2),2);
    dr(:,kk+1) = tmp(:,end);
    
end

end