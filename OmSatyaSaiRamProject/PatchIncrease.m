%% Clear and Close
clc;
clear;
close all;

%% Reading an image

Img1 = imread('D2.1.jpg');
Img2 = imread('D3.3.jpg');
Img3 = imread('D4.5.jpg');
Img4 = imread('D5.7.jpg');
Img5 = imread('D6.6.jpg');
Img6 = imread('D7.1.jpg');
subplot(3,6,1);
imshow(Img1)
title('Day - 2');
subplot(3,6,2);
imshow(Img2)
title('Day - 3');
subplot(3,6,3);
imshow(Img3)
title('Day - 4');
subplot(3,6,4);
imshow(Img4)
title('Day - 5');
subplot(3,6,5);
imshow(Img5)
title('Day - 6');
subplot(3,6,6);
imshow(Img6)
title('Day - 7');

%% 

GImg1 = rgb2gray(Img1);
GImg2 = rgb2gray(Img2);
GImg3 = rgb2gray(Img3);
GImg4 = rgb2gray(Img4);
GImg5 = rgb2gray(Img5);
GImg6 = rgb2gray(Img6);
% subplot(3,3,4);
% imshow(GImg);
% title('Gray Image');
% subplot(3,3,8);
% imhist(GImg);
% title('Histogram of Gray Image');

%% Background Removal
% Removing background using BackgroundRemoval function
[bw1,BRImg1] = BackgroundRemovalD7(Img1);
[bw2,BRImg2] = BackgroundRemovalD7(Img2);
[bw3,BRImg3] = BackgroundRemovalD7(Img3);
[bw4,BRImg4] = BackgroundRemovalD7(Img4);
[bw5,BRImg5] = BackgroundRemovalD7(Img5);
[bw6,BRImg6] = BackgroundRemovalD7(Img6);
BW1 = imfill(bw1,'holes');
BW2 = imfill(bw2,'holes');
BW3 = imfill(bw3,'holes');
BW4 = imfill(bw4,'holes');
BW5 = imfill(bw5,'holes');
BW6 = imfill(bw6,'holes');
uBW1 = im2uint8(BW1);
uBW2 = im2uint8(BW2);
uBW3 = im2uint8(BW3);
uBW4 = im2uint8(BW4);
uBW5 = im2uint8(BW5);
uBW6 = im2uint8(BW6);
% subplot(3,3,3);
% imshow(BW);
% title('B&W Object Image');

%% Identify the Object
% inverting black and white values
Ibw1 = imcomplement(uBW1);
Ibw2 = imcomplement(uBW2);
Ibw3 = imcomplement(uBW3);
Ibw4 = imcomplement(uBW4);
Ibw5 = imcomplement(uBW5);
Ibw6 = imcomplement(uBW6);
% subplot(3,3,2);
% imshow(BRImg);
% title('Foreground Object Image');
% Subtract Inverted BW values from Gray image
Gobj1 = imsubtract(GImg1,Ibw1);
Gobj2 = imsubtract(GImg2,Ibw2);
Gobj3 = imsubtract(GImg3,Ibw3);
Gobj4 = imsubtract(GImg4,Ibw4);
Gobj5 = imsubtract(GImg5,Ibw5);
Gobj6 = imsubtract(GImg6,Ibw6);
% subplot(3,6,7);
% imshow(Gobj1)
% subplot(3,6,8);
% imshow(Gobj2)
% subplot(3,6,9);
% imshow(Gobj3)
% subplot(3,6,10);
% imshow(Gobj4)
% subplot(3,6,11);
% imshow(Gobj5)
% subplot(3,6,12);
% imshow(Gobj6)
% subplot(3,3,5);
% imshow(Gobj);
% title('Gray Object');

%% Adujust the Brightness of the image

% ref = imread('D1.1.jpg');
% img = imread('Test1.5.jpg');
% 
% refr = ref(:,:,1);
% refg = ref(:,:,2);
% refb = ref(:,:,3);
% 
% imgr = img(:,:,1);
% imgg = img(:,:,2);
% imgb = img(:,:,3);
% 
% hirefr = imhist(refr);
% hirefg = imhist(refg);
% hirefb = imhist(refb);
% 
% outr = histeq(imgr,hirefr);
% outg = histeq(imgr,hirefg);
% outb = histeq(imgr,hirefb);
% 
% outimg(:,:,1) = outr;
% outimg(:,:,2) = outg;
% outimg(:,:,3) = outb;
% 
% subplot(1,3,1);
% imshow(img);
% subplot(1,3,2);
% imshow(ref);
% subplot(1,3,3);
% imshow(outimg);

%% Look for Pathches on the Object
Patch1 = Gobj1>100;
Patch2 = Gobj2>100;
Patch3 = Gobj3>100;
Patch4 = Gobj4>100;
Patch5 = Gobj5>100;
Patch6 = Gobj6>100;
Wpatch1 = imcomplement(Patch1);
Wpatch2 = imcomplement(Patch2);
Wpatch3 = imcomplement(Patch3);
Wpatch4 = imcomplement(Patch4);
Wpatch5 = imcomplement(Patch5);
Wpatch6 = imcomplement(Patch6);
subplot(2,6,7);
imshow(Wpatch1)
subplot(2,6,8);
imshow(Wpatch2)
subplot(2,6,9);
imshow(Wpatch3)
subplot(2,6,10);
imshow(Wpatch4)
subplot(2,6,11);
imshow(Wpatch5)
subplot(2,6,12);
imshow(Wpatch6)

%% %% Measure the size of the fruit
[B1,ib1,id1] = unique(bw1);b_counts1 = accumarray(id1,1);uniq_counts1 = [B1, b_counts1];hpart1 = uniq_counts1(2,2);
[B2,ib2,id2] = unique(bw2);b_counts2 = accumarray(id2,1);uniq_counts2 = [B2, b_counts2];hpart2 = uniq_counts2(2,2);
[B3,ib3,id3] = unique(bw3);b_counts3 = accumarray(id3,1);uniq_counts3 = [B3, b_counts3];hpart3 = uniq_counts3(2,2);
[B4,ib4,id4] = unique(bw4);b_counts4 = accumarray(id4,1);uniq_counts4 = [B4, b_counts4];hpart4 = uniq_counts4(2,2);
[B5,ib5,id5] = unique(bw5);b_counts5 = accumarray(id5,1);uniq_counts5 = [B5, b_counts5];hpart5 = uniq_counts5(2,2);
[B6,ib6,id6] = unique(bw6);b_counts6 = accumarray(id6,1);uniq_counts6 = [B6, b_counts6];hpart6 = uniq_counts6(2,2);

%% Measure the size of the Patches
[C1,ia1,ic1] = unique(Wpatch1);a_counts1 = accumarray(ic1,1);value_counts1 = [C1, a_counts1];spart1 = value_counts1(1,2);
[C2,ia2,ic2] = unique(Wpatch2);a_counts2 = accumarray(ic2,1);value_counts2 = [C2, a_counts2];spart2 = value_counts2(1,2);
[C3,ia3,ic3] = unique(Wpatch3);a_counts3 = accumarray(ic3,1);value_counts3 = [C3, a_counts3];spart3 = value_counts3(1,2);
[C4,ia4,ic4] = unique(Wpatch4);a_counts4 = accumarray(ic4,1);value_counts4 = [C4, a_counts4];spart4 = value_counts4(1,2);
[C5,ia5,ic5] = unique(Wpatch5);a_counts5 = accumarray(ic5,1);value_counts5 = [C5, a_counts5];spart5 = value_counts5(1,2);
[C6,ia6,ic6] = unique(Wpatch6);a_counts6 = accumarray(ic6,1);value_counts6 = [C6, a_counts6];spart6 = value_counts6(1,2);

%% Output

HP1 = (spart1/hpart1) * 100;
HP2 = (spart2/hpart2) * 100;
HP3 = (spart3/hpart3) * 100;
HP4 = (spart4/hpart4) * 100;
HP5 = (spart5/hpart5) * 100;
HP6 = (spart6/hpart6) * 100;
disp("Fruit health percentages based on days");
disp("Day-2 ---> " + HP1);
disp("Day-3 ---> " + HP2);
disp("Day-4 ---> " + HP3);
disp("Day-5 ---> " + HP4);
disp("Day-6 ---> " + HP5);
disp("Day-7 ---> " + HP6);

