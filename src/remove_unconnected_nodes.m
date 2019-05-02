function [faces_out,idx] = remove_unconnected_nodes(faces_input)

% points_input and faces_input define the input mesh. The output mesh is obtained 
% by removing the unconnected nodes.
% idx is such that points_output = points_input(idx,:);

[idx,~,ic] = unique(faces_input(:));
id_new = 1:numel(idx);
faces_out = reshape(id_new(ic),size(faces_input));

