%% Clear and Close
clc;
clear;
close all;

%% Reading an image

Img = imread('D7.2.jpg');
subplot(3,3,1);
imshow(Img)
title('Original Image');
subplot(3,3,7);
imhist(Img);
title('Histogram of Original Image');

%% Converting RGB image to Gray 

GImg = rgb2gray(Img);
subplot(3,3,4);
imshow(GImg);
title('Gray Image');
subplot(3,3,8);
imhist(GImg);
title('Histogram of Gray Image');

%% Splitting Image into R, G and B images

Imgr = Img(:,:,1);
Imgg = Img(:,:,2);
Imgb = Img(:,:,3);

%% Background Removal
% Removing background using BackgroundRemoval function
[bw,BRImg] = BackgroundRemovalD7(Img);
BW = imfill(bw,'holes');
uBW = im2uint8(BW);
subplot(3,3,2);
imshow(BRImg);
title('Object Image');
subplot(3,3,3);
imshow(BW);
title('B&W Object Image');

%% Identify the Object
% inverting black and white values
Ibw = imcomplement(uBW);
% Subtract Inverted BW values from Gray image
Gobj = imsubtract(GImg,Ibw);
subplot(3,3,5);
imshow(Gobj);
title('Gray Object');

%% Look for Pathches on the Object
Patch = Gobj>100;
Wpatch = imcomplement(Patch);
subplot(3,3,6);
imshow(Wpatch);
title('Helathy Part')

%% %% Measure the size of the fruit
[B,ib,id] = unique(bw);
b_counts = accumarray(id,1);
uniq_counts = [B, b_counts];
hpart = uniq_counts(2,2);

%% Measure the size of the Patches
[C,ia,ic] = unique(Wpatch);
a_counts = accumarray(ic,1);
value_counts = [C, a_counts];
spart = value_counts(1,2);

%% Finding the Thresholds

Rsa = sort(unique(Imgr));
Rsd = sort(unique(Imgr),'descend');
Gsa = sort(unique(Imgg));
Gsd = sort(unique(Imgg),'descend');
Bsa = sort(unique(Imgb));
Bsd = sort(unique(Imgb),'descend');
Lr = Rsa(2,1);
Hr = Rsd(1:1);
Lg = Gsa(2,1);
Hg = Gsd(1:1);
Lb = Bsa(2,1);
Hb = Bsd(1:1);

%% Compare the Threshold of color and size of the patch

disp("Based on the color thresholds");

if(Lr>=37&&Lr<=63&&Hr>=225&&Hr<=235 && Lg>=29&&Lg<=50&&Hg>=216&&Hg<=229 && Lb>=1&&Lb<=23&&Hb>=207&&Hb<=217)
    disp(1);
end
if(Lr>=18&&Lr<=33&&Hr>=231&&Hr<=237 && Lg>=9&&Lg<=20&&Hg>=222&&Hg<=228 && Lb==1&&Hb>=209&&Hb<=219)
    disp(2);
end
if(Lr>=4&&Lr<=10&&Hr>=221&&Hr<=241 && Lg>=1&&Lg<=3&&Hg>=214&&Hg<=232 && Lb==1&&Hb>=202&&Hb<=215)
    disp(3);
end
if(Lr>=5&&Lr<=16&&Hr>=222&&Hr<=231 && Lg>=1&&Lg<=9&&Hg>=214&&Hg<=228 && Lb==1&&Hb>=202&&Hb<=214)
    disp(4);
end
if(Lr>=5&&Lr<=9&&Hr>=224&&Hr<=238 && Lg>=1&&Lg<=4&&Hg>=214&&Hg<=231 && Lb==1&&Hb>=202&&Hb<=215)
    disp(5);
end
if(Lr>=4&&Lr<=12&&Hr>=225&&Hr<=230 && Lg>=1&&Lg<=8&&Hg>=215&&Hg<=223 && Lb==1&&Hb>=205&&Hb<=211)
    disp(6);
end
if(Lr>=4&&Lr<=7&&Hr>=224&&Hr<=238 && Lg>=1&&Lg<=3&&Hg>=215&&Hg<=234 && Lb==1&&Hb>=204&&Hb<=223)
    disp(7);
end

%% Based on fruit health percentage

HP = (spart/hpart) * 100;

disp("Based on health percentage");

if(HP >= 99.53 && HP <= 118.57)
    disp(1)
end
if(HP >= 96.5181 && HP <= 100.4283)
    disp(2)
end
if(HP >= 85.0874 && HP <= 92.0616)
    disp(3)
end
if(HP >= 84.9794 && HP <= 91.8341)
    disp(4)
end
if(HP >= 80.5140 && HP <= 89.8703)
    disp(5)
end
if(HP >= 78.3204 && HP <= 87.2770)
   disp(6)
end
if(HP >= 80.1095 && HP <= 88.4009)
   disp(7)
end

%% Based on average of Gray fruit image

[m,n] = size(Gobj); 
tot = sum(sum(Gobj));
check = tot/(m*n);
disp("Based on Gray image average");

if(check >= 5.3871 && check <= 6.7136)
    disp(7)
elseif(check >= 4.4596 && check <= 4.7705)
    disp(6)
elseif(check >= 4.1642 && check <= 4.7918)
    disp(5)
elseif(check >= 4.4766 && check <= 5.3118)
    disp(4)
elseif(check >= 5.1068 && check <= 5.4907)
    disp(3)
elseif(check >= 5.0872 && check <= 5.4646)
    disp(2)
elseif(check >= 5.3911 && check <= 5.8421)
    disp(1)
else
    disp("No Match")
end


%% Return the Output

disp("Healthy percent of fruit from image is ---> " + HP);



