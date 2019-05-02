function maskDicom(ImData,savename)

dragging = [];
orPos = [];
im0 = ImData.im(:,:,1);
imSave = [];

% -- figure
f = figure('WindowButtonUpFcn',@dropObject,...
    'position',[12   183   764   635],...
    'units','pixels','WindowButtonMotionFcn',@moveObject);
hax = axes('Parent',f,'Units','normalized');
imagesc(ImData.x,ImData.y,im0,'Parent',hax), axis image, colormap gray, hold on,


% -- figure for result
f2 = figure('position',[800   183   764   635],'units','pixels');
hax2 = axes('Parent',f2,'Units','normalized');
imagesc(ImData.x,ImData.y,zeros(size(im0)),'Parent',hax2), axis image, colormap gray,

% -- apply result
happly = uicontrol('Style','pushbutton','String','apply','Position',[670,220,70,25],'Parent',f);
hsave = uicontrol('Style','pushbutton','String','save','Position',[670,250,70,25],'Parent',f);
hclose = uicontrol('Style','pushbutton','String','close','Position',[670,280,70,25],'Parent',f);

% -- plot 3 points and connect with lines
figure(f)
[xii,yii] = ginput(1);
hP1 = plot(xii,yii,'go','markersize',14,'linewidth',2,'markerfacecolor','g','Parent',hax);

[xii,yii] = ginput(1);
hP2 = plot(xii,yii,'ro','markersize',14,'linewidth',2,'markerfacecolor','r','Parent',hax);
hL12 = line([get(hP1,'XData'),get(hP2,'XData')],...
    [get(hP1,'YData'),get(hP2,'YData')],'LineWidth',1,'color','w','Parent',hax);

% -- draw circle
hCirc = drawCircle(hP1,hP2);

hP3 = AssignSymmetricPoint(hP1,hP2);
hL23 = line([get(hP2,'XData'),get(hP3,'XData')],...
    [get(hP2,'YData'),get(hP3,'YData')],'LineWidth',1,'color','w','Parent',hax);

set(hP1,'ButtonDownFcn',@dragObject);
set(hP2,'ButtonDownFcn',@dragObject);
set(hP3,'ButtonDownFcn',@dragObject);
set(happly,'units','normalized','Callback',@ApplyMask);
set(hsave,'units','normalized','Callback',@SaveData);
set(hclose,'units','normalized','Callback',@CloseAll);

% hold off


    function ApplyMask(source,eventdata)
        mask = computeMask(hP1,hP2,hP3,ImData.x,ImData.y);
        imMasked = im0.*mask;
        imagesc(ImData.x,ImData.y,imMasked,'Parent',hax2),
        axis(hax2,'image')
        
        id = find(mask == 1);
        [I,J] = ind2sub(size(mask),id);
        xmin = min(J(:));
        xmax = max(J(:));
        ymin = min(I(:));
        ymax = max(I(:));
        xlim(hax2,ImData.x([xmin,xmax]));
        ylim(hax2,ImData.y([ymin,ymax]));
        
    end

    function CloseAll(source,eventdata)
        close(f)
        close(f2)
    end

    function SaveData(source,eventdata)
        mask = computeMask(hP1,hP2,hP3,ImData.x,ImData.y);
        imSave = ImData.im .* repmat(mask,[1 1 size(ImData.im,3)]);
        id = find(mask == 1);
        [I,J] = ind2sub(size(mask),id);
        xmin = min(J(:));
        xmax = max(J(:));
        ymin = min(I(:));
        ymax = max(I(:));
        USData.tissue = imSave(ymin:ymax,xmin:xmax,:);
        
        
        % FOV
        [rmax,t0,tf] = computeScan(hP1,hP2,hP3);
        tscan = t0 - tf;
        USInfo.rmax = rmax;
        USInfo.t0 = t0;
        USInfo.tscan = tscan;
        USInfo.r0 = 0;
        USInfo.pixelsize = [diff(ImData.y(1:2)) diff(ImData.x(1:2))];
        USInfo.gridsize = [size(USData.tissue,1) size(USData.tissue,2)];
        USInfo.frames = size(ImData.im,3);
        % mask sequence
        
        save(savename,'USInfo','USData');
    end

    function [rmax,t0,tf] = computeScan(h1,h2,h3)
        x2 = get(h2,'XData'); % center
        y2 = get(h2,'YData');
        
        x1 = get(h1,'XData'); % point on circle
        y1 = get(h1,'YData');
        
        x3 = get(h3,'XData'); % point on circle
        y3 = get(h3,'YData');
        
        v1 = (x1-x2) + 1j*(y1-y2);
        v3 = (x3-x2) + 1j*(y3-y2);
        
        t0 = angle(v1);
        tf = angle(v3);
        rmax = norm(v1);
        
    end

    function mask = computeMask(h1,h2,h3,x,y)
        
        [X,Y] = meshgrid(x,y);
        
        x2 = get(h2,'XData'); % center
        y2 = get(h2,'YData');
        
        %         x1 = get(h1,'XData'); % point on circle
        %         y1 = get(h1,'YData');
        %         x3 = get(h3,'XData'); % point on circle
        %         y3 = get(h3,'YData');
        
        % --
        X = X - x2; % center
        Y = Y - y2;
        
        [rmax,t0,tf] = computeScan(h1,h2,h3);
        V = X + 1j*Y;
        TH = angle(V);
        RHO = sqrt(X.^2 + Y.^2);
        mask = RHO < rmax & TH < t0 & TH > tf;
        
    end

    function hCirc = drawCircle(h1,h2)
        % - h2 is the center
        [xCirc,yCirc] = get_xy_circ(h1,h2);
        hCirc = plot(xCirc,yCirc,'w--','Parent',hax);
    end

    function [xCirc,yCirc] = get_xy_circ(h1,h2)
        th = linspace(0,2*pi,256);
        xCenter = get(h2,'XData');
        yCenter = get(h2,'YData');
        radius = sqrt((xCenter - get(h1,'XData'))^2 + (yCenter - get(h1,'YData'))^2);
        xCirc = xCenter + radius*cos(th);
        yCirc = yCenter + radius*sin(th);
    end

    function [x3,y3] = getSymmetricPointCoordinates(h1,h2)
        x2 = get(h2,'XData'); % center
        y2 = get(h2,'YData');
        
        x1 = get(h1,'XData'); % point on circle
        y1 = get(h1,'YData');
        
        v1 = (x1-x2) + 1j*(y1-y2);
        
        %         if angle(v1) > pi/2
        th3 = pi - angle(v1);
        %         else
        
        r3 = norm(v1);
        
        x3 = x2 + real(r3*exp(1j*th3));
        y3 = y2 + imag(r3*exp(1j*th3));
    end


    function h3 = AssignSymmetricPoint(h1,h2)
        [x3,y3] = getSymmetricPointCoordinates(h1,h2);
        h3 = plot(x3,y3,'wo','markersize',14,'linewidth',1,'markerfacecolor','w','Parent',hax);
    end


    function dragObject(hObject,eventdata)
        dragging = hObject;
        orPos = getCoordinates(hax);
    end

    function pos = getCoordinates(h_axes)
        tmp = get(h_axes,'currentpoint');
        pos = [tmp(1,1),tmp(1,2)];
    end

    function dropObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = getCoordinates(hax);
            
            posDiff = newPos - orPos;
            set(dragging,'XData',get(dragging,'XData')+posDiff(1),...
                'YData',get(dragging,'YData')+posDiff(2));
            dragging = [];
        end
    end

    function moveObject(hObject,eventdata)
        if ~isempty(dragging)
            newPos = getCoordinates(hax);
            posDiff = newPos - orPos;
            
            xd = get(dragging,'XData')+posDiff(1);
            yd = get(dragging,'YData')+posDiff(2);
            
            orPos = newPos;
            
            set(dragging,'XData',xd,'YData',yd);
            
            %             xd = get(dragging,'XData');
            %             yd = get(dragging,'YData');
            
            if dragging == hP1
                % -- update line
                xL12 = get(hL12,'XData');
                yL12 = get(hL12,'YData');
                xL12(1) = xd;
                yL12(1) = yd;
                set(hL12,'XData',xL12,'YData',yL12);
                
                % -- update circle
                [xCirc,yCirc] = get_xy_circ(dragging,hP2);
                set(hCirc,'XData',xCirc,'YData',yCirc);
                
                % -- map 
                [x3,y3] = getSymmetricPointCoordinates(dragging,hP2);
                set(hP3,'XData',x3,'YData',y3);
                
                % -- update line 23
                xL23 = get(hL23,'XData');
                yL23 = get(hL23,'YData');
                xL23(2) = x3;
                yL23(2) = y3;
                set(hL23,'XData',xL23,'YData',yL23);
                
            elseif dragging == hP2
                
                % -- update segments
                xL12 = get(hL12,'XData');
                yL12 = get(hL12,'YData');
                xL12(2) = xd;
                yL12(2) = yd;
                set(hL12,'XData',xL12,'YData',yL12);
                
                xL23 = get(hL23,'XData');
                yL23 = get(hL23,'YData');
                xL23(1) = xd;
                yL23(1) = yd;
                set(hL23,'XData',xL23,'YData',yL23);
                
                % -- update circle
                [xCirc,yCirc] = get_xy_circ(hP1,dragging);
                set(hCirc,'XData',xCirc,'YData',yCirc);
                
                % -- map 3
                [x3,y3] = getSymmetricPointCoordinates(hP1,dragging);
                set(hP3,'XData',x3,'YData',y3);
                
                % -- update line 23
                xL23 = get(hL23,'XData');
                yL23 = get(hL23,'YData');
                xL23(2) = x3;
                yL23(2) = y3;
                set(hL23,'XData',xL23,'YData',yL23);
                
            elseif dragging == hP3
                xL23 = get(hL23,'XData');
                yL23 = get(hL23,'YData');
                xL23(2) = xd;
                yL23(2) = yd;
                set(hL23,'XData',xL23,'YData',yL23);
                
                % map 2
                [x3,y3] = getSymmetricPointCoordinates(dragging,hP2);
                set(hP1,'XData',x3,'YData',y3);
                
                % -- update line
                xL12 = get(hL12,'XData');
                yL12 = get(hL12,'YData');
                xL12(1) = x3;
                yL12(1) = y3;
                set(hL12,'XData',xL12,'YData',yL12);
                
                % -- update circle
                [xCirc,yCirc] = get_xy_circ(dragging,hP2);
                set(hCirc,'XData',xCirc,'YData',yCirc);
                
                
                
            end
            
            % -- map h3 to circle
            
            
            
        end
    end
end