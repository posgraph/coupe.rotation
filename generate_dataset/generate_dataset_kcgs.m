clear;

list = dir('/home/eunbin/Matlab/genMyData/city_dataset/images/');

n_file = size(list, 1);
num = 0;
max_angle = 20;
n = 1;
for ex = 3:n_file + 2
    fname = list(ex).name;
    [~, name, ext] = fileparts(fname);
    if strcmp(name, 'Thumbs')
        continue;
    end
    
    im = imread(strcat('images/', fname));
    info = imfinfo(strcat('images/', fname));
    
    if (strcmp(info.Format, 'jpg') == 0)
        delete(strcat('images/', fname));
    end
    
    [height, width, c] = size(im);
    line_info = 0;
    
    endPoints = getLine(im);
    if (endPoints(1,1) == -1)
        continue;
    end
    if (endPoints(1,1) == 0) && (endPoints(1,2) == 0) && (endPoints(2,1) == 0) && (endPoints(2,2) == 0)
        line_info = 0;
    elseif (size(endPoints,1) ~= 2)
        continue;
    else
        line_info = 1;
    end
    
    % line이 없는 사진이면 
    if (line_info == 0)
        
        % label range : 0 ~ 40
        % original image's label : 20
        label = 20;
        imwrite(im, sprintf('/media/eunbin/Data2/KCGS_rotation/dataset/no_line_test/%s%.4f%s',strcat(name, '_'), label, '.jpg'));
        
        for n = 1 : 7
            angle = -max_angle + rand(1,1) * (max_angle + max_angle);
            % score = 1 - (abs(angle)/max_angle);
            label = angle + 20;
            
            s = ceil(size(im)/2);
            im_padding = padarray(im, s(1:2), 'symmetric', 'both');
            %figure; imshow(im_padding);
            im_rotate = imrotate(im_padding, angle, 'bilinear', 'crop');
            %figure; imshow(im_rotate);
            S = ceil(size(im_rotate)/2);
            im_final = im_rotate(S(1)-s(1):S(1)+s(1)-1, S(2)-s(2):S(2)+s(2)-1, :);
            %figure; imshow(im_final);
            %disp(angle);
            imwrite(im_final, sprintf('/media/eunbin/Data2/KCGS_rotation/dataset/no_line/%s%.4f%s',strcat(name, '_'), label, '.jpg'));
        end
        num = num + 1;
        disp(num);
    else
        
        % label range : 0 ~ 40
        % original image's label : 20
        label = 20;
        imwrite(im, sprintf('/media/eunbin/Data2/KCGS_rotation/dataset/line/%s%.4f%s',strcat(name, '_'), label, '.jpg'));
        
        for n = 1 : 7
            angle = -max_angle + rand(1,1) * (max_angle + max_angle);
            % score = 1 - (abs(angle)/max_angle);
            label = angle + 20;
            
            s = ceil(size(im)/2);
            im_padding = padarray(im, s(1:2), 'symmetric', 'both');
            %figure; imshow(im_padding);
            im_rotate = imrotate(im_padding, angle, 'bilinear', 'crop');
            %figure; imshow(im_rotate);
            S = ceil(size(im_rotate)/2);
            im_final = im_rotate(S(1)-s(1):S(1)+s(1)-1, S(2)-s(2):S(2)+s(2)-1, :);
            %figure; imshow(im_final);
            %disp(angle);
            imwrite(im_final, sprintf('/media/eunbin/Data2/KCGS_rotation/dataset/line/%s%.4f%s',strcat(name, '_'), label, '.jpg'));
        end
        num = num + 1;
        disp(num);
        
        
    end
end

    