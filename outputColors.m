clc; clear all; close all;

%~~~~~~~~ONLY EDIT THESE VARIABLES BELOW~~~~~~~~~%
%desired size of icons (they are square)
dimension_x = 10;
dimension_y = 10;
%do you want only unique icons?
uniqueIcons = false;
%do you want to replace in a grid or with random overlap?
% choose pixel overlap from 0 to 1; 0 = grid
overlap = 0.3;
%input image to fill in
A = imread('IMG-20150518-WA0003.jpg');
%~~~~~~~~ONLY EDIT THESE VARIABLES ABOVE~~~~~~~~~%

srcFiles = dir('iconpngs/*.png');
blankresult = A;
%before color matching, find avg colors of all images
avgTops=[];

for i = 1:length(srcFiles)
   fn = strcat('iconpngs/',srcFiles(i).name);
   B = imread(fn);
   avgTop = mean(mean(B));
   avgTops = [avgTops,avgTop];
end 

disp('wait a min');
%j is row number of images
%find by dividing the height of input image by icon dimension
for j = 0:floor(size(A,1)/dimension_y)-1
    %disp(j)
    %k is column number of images
    for k = 0:floor(size(A,2)/dimension_x)-1
        crop_h = dimension_y; 
        crop_w = dimension_x; 
        start_x = 1+(k*crop_w);
        start_y = 1+((j)*crop_h);

        locationCrop = [start_x start_y crop_w crop_h];
        Abottom = imcrop(A,locationCrop);
        %find the avg r,g,b of the area to replace
        avgBottom = mean(mean(Abottom));
        clor = roundn(avgBottom/255,-1);
        
        %find the abs value between r,g,b in question and 
        %all possible icon r,g,b values
        a1 = abs(avgTops(:,:,1)-avgBottom(:,:,1));
        a2 = abs(avgTops(:,:,2)-avgBottom(:,:,2));
        a3 = abs(avgTops(:,:,3)-avgBottom(:,:,3));
        
        aF = a1+a2+a3;
        %find which icon's r,g,b values are closest to 
        %the one in question
        [dist,index]=min( aF );

        matchfile = strcat('iconpngs/',srcFiles(index).name);
        
        clr = roundn(avgTops(:,index,:)/255,-1);
        matchedImage = imread(matchfile);
        scaledScreenshot = imresize(matchedImage, [crop_h crop_w]);
        %adjust where to place icon based on value of overlap
        normOverlap_y = floor(overlap*dimension_y*rand(1));
        normOverlap_x = floor(overlap*dimension_x*rand(1));
        start_y = start_y + normOverlap_y;
        start_x = start_x + normOverlap_x;
        if rand(1) > 0.5 
            blankresult(start_y:start_y+crop_h-1,start_x:start_x+crop_w-1,:) = scaledScreenshot(:,:,:);
        end
        %delete matched screenshot record 
        %from avg Color record and from srcFiles
        if uniqueIcons == true 
            avgTops(:,index,:) =[];
            srcFiles(index) = [];
            disp(length(srcFiles));
        end
    end
end

imshow(blankresult)

str = strcat('outputImages/',datestr(now,1),'-',datestr(now,15),'.jpg');
imwrite(blankresult,str);


