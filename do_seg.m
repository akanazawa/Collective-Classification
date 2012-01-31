function do_seg(config_file)
%%%%%%%%%%
% do_seg.m
% Supersegments all N images in IMG_DIR and saves them in SEG_FILE where 
% the data is in a N x 1 cell where each cell has the structure:
%     id: for the image file
%     file_path: the original img file path
%     labels: H x W matrix where each pixel is assigned a label
%                belonging to a region
%     gt: H x W pixel-wise 
%
% Saves the data in SEG_FILE specified in config.m
%
% Using Ming-yu's Entropy Rate Superpixel Segmentation code 
% http://www.umiacs.umd.edu/~mingyliu/research.html
%
% Settings used for Ming-yu's supersegmentation algorithm is
% specified in SEG variable set in config.m
%%%%%%%%%%

%% Evaluate global configuration file and load parameters
eval(config_file);

%% Load images
if ~exist([SEG_FILE])
    content = dir(IMG_DIR);
    names = {content.name} ;
    ok = regexpi(names, '.*\.(jpg|png|jpeg|gif|bmp|tiff)$', 'start') ;
    names = names(~cellfun(@isempty,ok)) ;    
    seg = cell(size(names));
    for i = 1:length(names)
        %% get id before .jpg
        seg{i}.id = cell2mat(regexp(names{i}, '[^\.jpg]', 'match'));
        seg{i}.file_path = fullfile(IMG_DIR,names{i});
        img = imread(seg{i}.file_path);
        %% get the true label        
        seg{i}.gt = single(textread([GT_DIR, seg{i}.id, gt_ext]));
        %% segment the image
        t = cputime;
        seg{i}.labels = single(mex_ers(double(img), SEG.nC));
        fprintf(1,'Use %f sec. \n',cputime-t);
        fprintf(1,['\t to divide the image(%s) into %d superpixels.\' ...
                   'n'],names{i},SEG.nC);
        %% ----- show results for the first 10-----
        if i < 11            
            subplot(121); imagesc(img);
            % draw boundary
            gray_img = rgb2gray(img);
            [height width] = size(gray_img);
            [bmap] = seg2bmap(seg{i}.labels,width,height);
            bmapOnGray_Img = gray_img;
            idx = find(bmap>0);
            timg = gray_img;
            timg(idx) = 1;
            bmapOnGray_Img(:,:,2) = timg;
            bmapOnGray_Img(:,:,1) = gray_img;
            bmapOnGray_Img(:,:,3) = gray_img;
            subplot(122); imagesc(bmapOnGray_Img);
        end
    end
    fprintf('super segmentation done!\n');
    save([SEG_FILE], 'seg');
end
