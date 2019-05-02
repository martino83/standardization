function segmentalStrainPrettyFigure(ref_A4C,strain,varargin)

if nargin < 3 || isempty(varargin{1})
    range = [min(strain(:)),max(strain(:))]; else, range = varargin{1}; end
if nargin < 4 || isempty(varargin{2})
    colorbar_mode = 1; else, colorbar_mode = varargin{2}; end
if nargin < 5 || isempty(varargin{3})
    direction = 1; else, direction = varargin{3}; end


A = load(ref_A4C);
[c,cmap] = assign_colors(strain, range, direction);
c_full = zeros(140,3);
D = A.X_gt;

tri = zeros(140,4);
[X,Y] = meshgrid(1:5,1:36);
cont = 0;
for idx = 1:4
    for idy = 1:35
        cont = cont+1;
        col_id = floor((idy-1)/6) + 1;
        xt = [X(idy,idx), X(idy, idx+1), X(idy+1, idx+1), X(idy+1,idx)];
        yt = [Y(idy,idx), Y(idy, idx+1), Y(idy+1, idx+1), Y(idy+1,idx)];
        idt = sub2ind([36,5],yt,xt);
        tri(cont,:) = idt;
        c_full(cont,:) = c(col_id,:);
    end
end
% c = randn(size(tri),1);

p = patch('Faces',tri,'Vertices',[D(:,1),D(:,3)],'FaceVertexCData',c_full,'Facecolor','flat','edgecolor','k');
axis ij image off

if colorbar_mode
    colormap(cmap);
    h = colorbar;
    set(h,'Limits',[0,1])
    set(h,'fontsize',12);
    % -- adjust ticks labels
    t = get(h,'TickLabels');
    for ii = 1:numel(t)
        
        l = str2double(t{ii});
        l = l * diff(range) + range(1);
        t{ii} = num2str(l,'%.2f');
        
    end
    set(h,'TickLabels',t);
end
debug();

end


function [c,cmap] = assign_colors(V, v_range, direction)

% cmap = colormap(cmap_type);
ncolors = 64;
switch direction
    case 'L'
        cmap = vivid(ncolors,'rb');
    case 'R'
        cmap = vivid(ncolors,'br');
end
cmap_neg = cmap(1:end/2,:);
cmap_pos = cmap(end/2+1:end,:);
step = diff(v_range) / (ncolors - 1);

nsteps_neg = floor(abs(v_range(1)) / step);
nsteps_pos = floor(abs(v_range(2)) / step);

cmap_neg = interp1(1:size(cmap_neg,1),cmap_neg,linspace(1,size(cmap_neg,1),nsteps_neg));
cmap_pos = interp1(1:size(cmap_pos,1),cmap_pos,linspace(1,size(cmap_pos,1),nsteps_pos));

cmap = [cmap_neg;cmap_pos];

n = size(cmap,1);
% ref0 = ceil(size(cmap,1)/2);
% id0 = round((-v_range(1)) / diff(v_range) * (n-1) + 1);
% diff0 = ref0 - id0;

id = round((V(:) - v_range(1)) / diff(v_range) * (n-1) + 1);
id(id<1) = 1;
id(id>n) = n;
c = cmap(id,:);

end