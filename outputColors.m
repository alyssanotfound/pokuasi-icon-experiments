clc; clear all; close all;

srcFiles = dir('iconpngs/*.jpg');
A = imread('gradient.png');


blankresult = A;
%before color matching, find avg colors of all images
 avgTops=[];
 
      for i = 1:length(srcFiles)
           fn = strcat('iconpngs/',srcFiles(i).name);
           B = imread(fn);
           avgTop = mean(mean(B));
           avgTops = [avgTops,avgTop];
      end 
%j is row number of images 1 to 72
for j = 0:140
    disp(j)
    %k is column number of images 0 to 8
    for k = 0:2
        crop_h = 400; %1000
        crop_w = 400; %2000
        start_x = 1+(k*crop_w);
        start_y = 1+((j)*crop_h);

        locationCrop = [start_x start_y crop_w crop_h];
        Abottom = imcrop(A,locationCrop);
      %  imshow(Abottom);
        avgBottom = mean(mean(Abottom));
        clor = roundn(avgBottom/255,-1);

        a1 = abs(avgTops(:,:,1)-avgBottom(:,:,1));
        a2 = abs(avgTops(:,:,2)-avgBottom(:,:,2));
        a3 = abs(avgTops(:,:,3)-avgBottom(:,:,3));
        aF = a1+a2+a3;
        [dist,index]=min( aF );
        

        matchfile = strcat('iconpngs/',srcFiles(index).name);
        
         disp(matchfile);
        clr = roundn(avgTops(:,index,:)/255,-1);
        %figure, imshow(matchfile);
        %rectangle('Position',[0,0,200,200],'FaceColor',clor);
        %rectangle('Position',[200,0,200,200],'FaceColor',clr);
         
         

        matchedImage = imread(matchfile);
        scaledScreenshot = imresize(matchedImage, [crop_h crop_w]);
    %     figure; imshow(scaledScreenshot);
    %     figure; imshow(blankresult(start_y:start_y+crop_h,start_x:start_x+crop_w,:));
        %disp(start_y);
        %disp(start_y+crop_h-1);
        %disp(start_x);
        %disp(start_x+crop_w-1);
        blankresult(start_y:start_y+crop_h-1,start_x:start_x+crop_w-1,1) = scaledScreenshot(:,:,1);
        blankresult(start_y:start_y+crop_h-1,start_x:start_x+crop_w-1,2) = scaledScreenshot(:,:,2);
        blankresult(start_y:start_y+crop_h-1,start_x:start_x+crop_w-1,3) = scaledScreenshot(:,:,3);
    %     imshow(blankresult);
    
    %move actual file into another directory
    %movefile(matchfile,'vliscoOutput.jpg');
    
    %delete matched screenshot record 
    %from avg Color record and from srcFiles
    avgTops(:,index,:) =[];
    srcFiles(index) = [];
    disp(length(srcFiles));
    end
end

imshow(blankresult)
imwrite(blankresult,'moises_output1.tif');


