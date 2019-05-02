function play_template(vendor,view_type,make_video)

srd_fname = fullfile('templates',vendor,[view_type '.srd']);
[im_sim,~,USInfo] = load_templates(srd_fname);

nframes = size(im_sim,3);

if make_video == 1
    savename = ['videos_template/' vendor '_' view_type];
    writerObj = VideoWriter(savename);
    open(writerObj);
    %     mov(1:nframes) = struct('cdata', [],'colormap', []);
end


% --
for ii = 1:nframes
    
    
    x = linspace(0,USInfo.pixelsize(2)*USInfo.gridsize(2),USInfo.gridsize(2));
    y = linspace(0,USInfo.pixelsize(1)*USInfo.gridsize(1),USInfo.gridsize(1));
    imagesc(x,y,im_sim(:,:,ii)), colormap gray, axis image,
    
    if make_video
        frame = getframe;
        writeVideo(writerObj,frame);
        %         mov(kk+1) = getframe(gcf);
    end
    drawnow
end

if make_video
    close(writerObj);
    
    %     movie2avi(mov,savename,'compression','None','fps',nframes);
end