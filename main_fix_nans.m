clc
close all
clear
addpath src

fid = fopen('log.txt','w');

% generates the ground truth:
% 1/ seed points are manually put on the first frame;
% 2/ they are moved according to the E/M model;
% 3/ the point might get lost over time
vendors = {'TOSHIBA_MEC_US','ESAOTE',...
    'SAMSUNG MEDISON CO','Siemens','Philips Medical Systems','GE Vingmed Ultrasound',...
    'Hitachi Aloka Medical,Ltd'};

for vendor_id = 1:numel(vendors)
    vendor = vendors{vendor_id};
    % choose views
    view_vec = {'A2C','A4C','A3C'};
    
    switch vendor
        case 'TOSHIBA_MEC_US'
            frame_rate = '60';
        case 'Siemens'
            frame_rate = '56';
        case 'Hitachi Aloka Medical,Ltd'
            frame_rate = '72';
        case 'GE Vingmed Ultrasound'
            frame_rate = '54';
        case 'ESAOTE'
            frame_rate = '54';
        case 'Philips Medical Systems'
            frame_rate = '50';
        case 'SAMSUNG MEDISON CO'
            frame_rate = '65';
    end
    
    seq_vec = {'normal','lcx','rca','laddist','ladprox'};
    
    for view_id = 1:numel(view_vec)
        for seq_id = 1:numel(seq_vec)
            seq = seq_vec{seq_id};
            view_name = view_vec{view_id};
            
            disp([vendor,' ', seq, ' ', view_name]);
            
            gt_name = ['data/ground_truth/' vendor '_' view_name '_' seq '.mat'];
            gt = load(gt_name);
            
            if (sum(isnan(gt.X_gt(:))) == 0)
                disp('no nans found!')
                continue;
            end
            
            % name of new ground truth file
            savename = ['data/ground_truth/fix/' vendor '_' view_name '_' seq '.mat'];
            
            % load info.
            infofile = ['data/info/info_' vendor '_' view_name '.mat'];
            load(infofile);
            %         x = linspace(0,USInfo.pixelsize(2)*USInfo.gridsize(2),USInfo.gridsize(2));
            %         y = linspace(0,USInfo.pixelsize(1)*USInfo.gridsize(1),USInfo.gridsize(1));
            
            %% use mask (main2) o align with 3D model
            load(['data/masks_for_alignment/mask_' lower(view_name) '.mat']); % reference
            T = USInfo.im2sim_transform;
            
            % -- apply transform to 3d meshes
            mesh_fname = ['data\3D_meshes\mesh_' seq '_' num2str(frame_rate) 'Hz.mat'];
            load(mesh_fname);
            npoints = size(X,1);
            nframes = size(X,3);
            x_mesh_tot = X(:,1,:);
            y_mesh_tot = X(:,2,:);
            z_mesh_tot = X(:,3,:);
            [X_matched] = apply_transform_to_mesh([x_mesh_tot(:),y_mesh_tot(:),z_mesh_tot(:)],mask_model,T,'non-rigid',[],USInfo.mask_reg.R);
            
            % transformed meshes
            x_mesh_trans = reshape(X_matched(:,1),[npoints,nframes]);
            y_mesh_trans = reshape(X_matched(:,2),[npoints,nframes]);
            z_mesh_trans = reshape(X_matched(:,3),[npoints,nframes]);
            
            % first mesh
            x_mesh0 = x_mesh_trans(:,1);
            y_mesh0 = y_mesh_trans(:,1);
            z_mesh0 = z_mesh_trans(:,1);
            
            % first frame
            nl = 36;
            nr = 5;
            nf = size(gt.X_gt,3);
            xp0 = squeeze(gt.X_gt(:,1,1));
            yp0 = squeeze(gt.X_gt(:,2,1));
            zp0 = squeeze(gt.X_gt(:,3,1));
            xp0 = reshape(xp0,[nl,nr]);
            yp0 = reshape(yp0,[nl,nr]);
            zp0 = reshape(zp0,[nl,nr]);
            
            % get baricentric coordinates
            TR0 = triangulation(Tri,[x_mesh0(:),y_mesh0(:),z_mesh0(:)]);
            [t0,BC0] = pointLocation(TR0,[xp0(:),yp0(:),zp0(:)]);
            
            % find index of nan points
            xpp = squeeze(gt.X_gt(:,1,:));
            zpp = squeeze(gt.X_gt(:,3,:));
            nan_ids_full_cycle = find(isnan(xpp) | isnan(zpp));
            [pos_l, pos_r, frame_id] = ind2sub([nl, nr, nf],nan_ids_full_cycle);
            % find spatial coordinates only.
            [C, ia, ic] = unique([pos_l, pos_r], 'rows');
            pos_l_frame0 = C(:,1);
            pos_r_frame0 = C(:,2);
            nan_ids_frame0 = sub2ind([nl, nr], pos_l_frame0, pos_r_frame0);
            disp(['found ',num2str(numel(nan_ids_frame0)),' nans'])
            %         figure(3)
            %         imagesc(x,y,zeros([numel(y), numel(x)])), colormap gray, axis image, hold on
            %         plot(xp(:),zp(:),'go')
            %         plot(xp(isnan(t)),zp(isnan(t)),'r*')
            
            % removing nans
            % squeeze
            max_trials = 100;
            
            % new ground truth without nans
            X_gt = zeros(numel(xp0),3,nframes);
            
            count_trials = 0;
            nan_fix_failed = false;

            w = 0.95; % compression factor (nan points are moved inwards towards mid myocardium, w=1 no compression, w=0 all layers merge)).
            done_fixing_nans = false;

            while not(done_fixing_nans) && not(nan_fix_failed)

                count_trials = count_trials+1;
                
                % Modified by Sandro -> shrink all NaN points, and only recompute baricentric coordinates and propagate afterwards. Otherwise, you change one
                % of them, but then test whether there is any NaN after recomputing and propagating (which exist, since you did not changed the others).
                for id_nan_point = 1:numel(nan_ids_frame0)
                    [point_id, layer_id] = ind2sub([nl,nr],nan_ids_frame0(id_nan_point));

                    xl = xp0(point_id,:);
                    zl = zp0(point_id,:);
                    dx = diff(xl);
                    dz = diff(zl);

                    fprintf('adjusting nans, iter: w: %f\n',w);
                    x_new = [xl(1),xl(1) + cumsum(w * dx)];
                    z_new = [zl(1),zl(1) + cumsum(w * dz)];
    
                    if layer_id == 1
                        x_new = x_new + (xl(end) - x_new(end));
                        z_new = z_new + (zl(end) - z_new(end));
                    end

                    % redistribute distance
                    xp0(point_id,:) = x_new;
                    zp0(point_id,:) = z_new;
                end
                
                X_gt(:,:,1) = [xp0(:),yp0(:),zp0(:)];

                % baricentric coordinates of nan points
                [t,BC] = pointLocation(TR0,[xp0(:),yp0(:),zp0(:)]);

                % -- propagate points

                xp = xp0;
                yp = yp0;
                zp = zp0;

                for id_frame = 2:nframes
                    disp([num2str(id_frame),'/',num2str(nframes)])

                    % mesh
                    x_meshii = x_mesh_trans(:,id_frame);
                    y_meshii = y_mesh_trans(:,id_frame);
                    z_meshii = z_mesh_trans(:,id_frame);
                    TR = triangulation(Tri,[x_meshii(:),y_meshii(:),z_meshii(:)]);

                    % propagate in 3d
                    PC = barycentricToCartesian(TR,t,BC);

                    % -- project to slice
                    xp = PC(:,1);
                    yp = zeros(size(xp));
                    zp = PC(:,3);

                    % -- rcompute bari coord
                    [t,BC] = pointLocation(TR,[xp,yp,zp]);

                    if (any(isnan(t))) % go back to frame and and squeeze a little more
                        %                         nan_ids_frame0 = find(isnan(t)); % points to adjust
                        disp('point became nan: go back to frame 0.');
                        break;
                    end

                    X_gt(:,:,id_frame) = [xp(:),yp(:),zp(:)];
                    if (id_frame == nframes)
                        done_fixing_nans = true;
                    end
                end
                if (count_trials == max_trials)
                    done_fixing_nans = true;
                    nan_fix_failed = true;
                    disp(['COULD NOT FIX NANS FOR ' vendor '_' view_name '_' seq])
                    fprintf(fid, 'COULD NOT FIX %s %s %s\n', vendor, view_name, seq);
                end
                
                if nan_fix_failed
                    break; % go to next sequence
                end
            end
            
            if nan_fix_failed
                nan_fix_failed = false;
                continue; % go to next sequence
            end
            aha = gt.aha;
            save(savename,'X_gt','aha');
            fprintf(fid, 'SAVING %s %s %s\n', vendor, view_name, seq);
            
            
        end
    end
end

fclose(fid);