function [] = ivc(filename)
   % flecha = imread('flecha.png');
    %flecha = rgb2gray(flecha);
    video = VideoReader(filename);
    figure;
    cont = 0;
    first = 1;
    recto = 0;
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
            stats = regionprops(cc, 'Area');
            a = [stats.Area];
            [M I] = max(a);
            idx = I;
            amax = ismember(L, idx);
            stats2 = regionprops(amax, 'Centroid');
            centro = [stats2.Centroid];
            if first == 1;
                recto = centro(:,1);
                first = 0;
            end
            %fueras = filled - amax(1:h, 1:j);
            %%%%negro = 0*gris;
            f = int32(centro(:,1));
            c = int32(centro(:,2));
            
            left = ['LEFT ', num2str(f)];
            right = ['RIGHT ', num2str(f)];
            mTextBox = uicontrol('style','text','Position', [80 50 50 20]);
            set(mTextBox,'BackgroundColor',[1 1 1]);
            if f < (recto - 50)
                set(mTextBox,'String','LEFT');
            elseif f > (recto + 50)
                set(mTextBox,'String','RIGHT');
            else
                set(mTextBox,'String','GO');
            end
                
            %amax = filled;
            %disp(c);
            %%%%negro(f,c) = 255;
            %%%%flecha2 = imtranslate(flecha, [f, c]);
            %%%%[r y] = size(flecha);
            %%%%negro(f+1:r,c+1:y) = flecha;
            %bw = amax;
            
        end
        cont = cont + 1;
        %rojo = cat(3, amax, amax, amax);
        rojo = cat(3, gris, gris, gris);
        image(rojo);
        hold on; plot(f,600,'r*'); hold off;
        title('Trabajo IVC', 'FontSize', 10);
        drawnow;
    end
    close;
end