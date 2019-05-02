function write_points_to_vtk(p,filename)

fid = fopen(filename,'w');
if(fid<0)
    fprintf('could not open file %s for writing\n',filename);
    return
end

% write header
fprintf(fid,'%s\n','# vtk DataFile Version 3.0');
fprintf(fid,'%s\n','world');
fprintf(fid,'%s\n','ASCII');
fprintf(fid,'%s\n','DATASET POLYDATA');

% write points
npoints = size(p,1);
p = [p,zeros(npoints,1)];

fprintf(fid,'POINTS %d float\n',npoints);
fprintf(fid,'%.3f %.3f %.3f\n',p');

%write vertices
v = 0:npoints-1;
v = [ones(npoints,1),v(:)];
fprintf(fid,'VERTICES %d %d\n',npoints,2*npoints);
fprintf(fid,'%d %d\n',v');
fclose(fid);
