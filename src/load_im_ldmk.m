function im_ldmk = load_im_ldmk(vendor,view_name)

[~,~,pointsFlist] = getTrackingFolder(vendor,view_name);
mesh = read_vtkMesh_martino1(pointsFlist(1,:));
nFiles = size(pointsFlist,1);
nPoints = mesh.npoints;
px = zeros(nPoints,nFiles);
pz = zeros(nPoints,nFiles);
parfor jj = 1:nFiles
    filename = pointsFlist(jj,:); % points
    mesh = read_vtkMesh_martino1(filename);
    px(:,jj) = mesh.points(:,2);
    pz(:,jj) = mesh.points(:,1);        
end

[J,I] = meshgrid(1:5,1:36);
id_keep = sub2ind([36,5],[I(:,1);I(:,5);I(1,:)';I(36,:)'],[J(:,1);J(:,5);J(1,:)';J(36,:)']);
id_keep = unique(id_keep);

px = px(id_keep,:);
pz = pz(id_keep,:);

% figure
% plot(px(:,1),pz(:,1),'bo')

im_ldmk = cat(3,px,pz);
im_ldmk = permute(im_ldmk,[1,3,2]);











