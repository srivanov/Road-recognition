function [] = ivc(filename)
   % flecha = imread('flecha.png');
    %flecha = rgb2gray(flecha);
    video = VideoReader(filename);
    figure;
    cont = 0;
    delay = 10;
    while hasFrame(video)
        frameOrig = readFrame(video);
        gris = rgb2gray(frameOrig);  
        
        
        if mod(cont,delay) == 0
            %aplicamos filtro de media
            filtro = fspecial('average');
            sin = imfilter(gris,filtro);
            open = imopen(sin, strel('square', 15));
            bw = im2bw(open, graythresh(gris));
            %%%%cielo = im2bw(rojo, 200/255);
            %linea = bw;
            bw = bwareaopen(bw, 5000);
            cc = bwconncomp(bw);
            L = labelmatrix(cc);
            stats = regionprops(cc, 'Area', 'Centroid');
            a = [stats.Area];
            centro = [stats.Centroid];
            [M I] = max(a);
            idx = I;
            amax = ismember(L, idx);
            %%%%negro = 0*gris;
            %f = int32(centro(idx));
            %c = int32(centro(idx+1));
            %disp(c);
            %%%%negro(f,c) = 255;
            %%%%flecha2 = imtranslate(flecha, [f, c]);
            %%%%[r y] = size(flecha);
            %%%%negro(f+1:r,c+1:y) = flecha;
            %bw = amax;
            rojo = cat(3, amax, amax, amax);
        end
        cont = cont + 1;
        %rojo = cat(3, gris, gris, gris);
        image(rojo);
        title('Trabajo IVC', 'FontSize', 10);
        drawnow;
    end

end