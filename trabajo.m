function [] = ivc(filename)

    video = VideoReader(filename);
    figure;
    
    while hasFrame(video)
        frameOrig = readFrame(video);
        
		image(frameOrig);
		title('Trabajo IVC', 'FontSize', 10);
		drawnow;
    end

end