function output = countSpotsByErosion(rgb)
rgb=imclearborder(rgb);
img2=im2bw(rgb,graythresh(rgb));
img2=~img2;
%figure,imshow(img2);
square=strel('square',1);
im_erod1=imerode(img2,square);
im_erod1=double(im_erod1);
img2=im2bw(im_erod1,graythresh(im_erod1));
%imshow(img2)
img2=~img2;
%CC = bwconncomp(img2);
% B = bwboundaries(img2);
% imshow(img2)
[B,L,N]= bwboundaries(img2);
[row, col]=size(B);
output= row - N;
end

