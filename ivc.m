function [] = ivc(filename)
    flecha = imread('flecha.png');
    flecha = rgb2gray(flecha);
    video = VideoReader(filename);
    figure;
    cont = 0;
    delay = 10;
    while hasFrame(video)
        frameOrig = readFrame(video);
        gris = rgb2gray(frameOrig);        
        if mod(cont,delay) == 0
            hg = im2bw(gris, graythresh(gris));
            %cielo = im2bw(rojo, 200/255);
            linea = hg;
            %linea = bwareaopen(linea, 1000);
            cc = bwconncomp(linea);
            L = labelmatrix(cc);
            stats = regionprops(cc, 'Area', 'Centroid');
            a = [stats.Area];
            centro = [stats.Centroid];
            [M I] = max(a);
            idx = I;
            bw2 = ismember(L, idx);
            negro = 0*gris;
            f = int32(centro(idx));
            c = int32(centro(idx+1));
            disp(c);
            negro(f,c) = 255;
            %flecha2 = imtranslate(flecha, [f, c]);
            %[r y] = size(flecha);
            %negro(f+1:r,c+1:y) = flecha;
            %linea = bw2;
            rojo = cat(3, negro, negro, negro);
        end
        cont = cont + 1;
        %rojo = cat(3, gris, gris, gris);
        image(rojo);
        title('Trabajo IVC', 'FontSize', 10);
        drawnow;
    end

end