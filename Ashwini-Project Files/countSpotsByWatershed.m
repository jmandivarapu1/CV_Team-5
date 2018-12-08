function output = countSpotsByWatershed(bw)

% % rgb = imread('banana2.jpg');
% % figure,imshow(rgb);
% grayImage = rgb2gray(rgb);
% %figure,imshow(rgb);
% %I= imresize(I, [500 500]);
% filterImage = imtophat(grayImage, strel('disk', 10));
% level1 = graythresh(filterImage);
% blackWhite = im2bw(filterImage,level1);
% value = -bwdist(~blackWhite);
% value(~blackWhite) = -Inf;
% L = watershed(value);
% % figure,imshow(label2rgb(L))
% % measurements = regionprops(L, 'Area', 'Perimeter', 'Centroid');
% %[~, numRegions] = bwlabel(L);
% img2=im2bw(label2rgb(L),graythresh(label2rgb(L)));
% %imshow(img2);
% img2=~img2;
% %imshow(img2);
% % cc = bwconncomp(img2, 4);
% % CC = bwconncomp(img2);
% % stats = regionprops(CC,'Image');
% [B1,L1,N1]= bwboundaries(img2);
% [row1, col1]=size(B1);
% output= row1 - N1;

%Actual code which take bw part

bw2 = ~bwareaopen(~bw, 10);
bw2=double(bw2);
img2=im2bw(bw2,graythresh(bw2));
img2=~img2;
CC = bwconncomp(img2);
stats = regionprops(CC,'Image');
[B1,L1,N1]= bwboundaries(img2);
output=N1;
%actaul part ends here

% imshow(img2); hold on;
% for k=2:length(B1)
%    boundary = B1{k};
%    if(k > N1)
%      plot(boundary(:,2), boundary(:,1), 'g','LineWidth',2);
%    else
%      plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
%    end
% end
end

