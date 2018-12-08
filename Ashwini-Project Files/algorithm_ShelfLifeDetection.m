clc;
close all;
clear all;
% Make sure the workspace panel is showing.
workspace;  
format long g;
format compact;

% Define a starting folder.
start_path = fullfile(pwd);
if ~exist(start_path, 'dir')
	start_path = pwd;
end

topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
fprintf('The top level folder is "%s".\n', topLevelFolder);

filePattern = sprintf('%s/*.png', topLevelFolder);
baseFileNames = dir(filePattern);
	% Add on TIF files.
filePattern = sprintf('%s/*.tif', topLevelFolder);
baseFileNames = [baseFileNames; dir(filePattern)];
	% Add on JPG files.
filePattern = sprintf('%s/*.jpg', topLevelFolder);
baseFileNames = [baseFileNames; dir(filePattern)];

cd(topLevelFolder);
%C = {'Image','Day','YellowPixels','BrownPixles','BlackPixles','SpoiledArea','SpotCount'};
featureArray={'Image','Day','YellowPixels','BrownPixles','BlackPixles','SpoiledArea','SpotCountByWatershed','SpotCountByVThreshold'};
for i = 1 : length(baseFileNames)
    fprintf('The top level folder is "%s".\n', baseFileNames(i).name);
    rgbImage = imread(baseFileNames(i).name);
    %rgbImage= imresize(rgbImage, [227 227]);
    %remove background from images
    [bw, rgb]=BGMask(rgbImage); %using LAB
    [bw1,rgb1]=createMask(rgbImage);%using HSV
    %Select file name to save processed files
    [filepath,filename,ext] = fileparts(baseFileNames(i).name);
    filenameSplit = strsplit(filename,'-');
    rgbImagePart=strcat(topLevelFolder,'\processed\',filename,'_WBG_', num2str(i),'.jpg');
    imwrite(rgb, rgbImagePart);
    bwImagePart=strcat(topLevelFolder,'\processed\',filename,'_BW_', num2str(i),'.jpg');
    rgbImagePart=strcat(topLevelFolder,'\processed\',filename,'_WBG1_', num2str(i),'.jpg');
    imwrite(rgb1, rgbImagePart);
    %imwrite(bw, bwImagePart);
    %get dominant pixel color count by HUE range
    imageColorLayer = colorDetectionByHue(rgb1); 
    yellow=imageColorLayer.yellow;
    yellowPixelCount=sum(yellow(:)); %yellow pixel count
    brown=imageColorLayer.brown;
    brownPixelCount=sum(brown(:)); %brown pixel count
    black=imageColorLayer.black;
    blackPixelCount=sum(black(:)); %black pixel count
    %spoiled area percentage
    areaPercentage=detectSpoiledArea(rgb1);
    %count spots by watershed
    spotCount1=countSpotsByWatershed(bw);
    %count spots based on v- value threshold
    spotCount2=countSpotsByVThreshold(rgbImagePart);
    spotCount3=countSpotsByErosion(rgb);
    imagename=strcat(filenameSplit{1},filenameSplit{2},filenameSplit{3});
    %records these values in feature in array
    if( i == 1)
       featureArray = {'Image','Day','YellowPixels','BrownPixles','BlackPixles','SpoiledArea','SpotCountByWatershed','SpotCountByVThreshold','spotCountByErosion','lasteddays'; imagename filenameSplit{3} yellowPixelCount brownPixelCount blackPixelCount areaPercentage spotCount1 spotCount2 spotCount3 filenameSplit{4}};
      % featureArray = {'1';yellowPixelCount;brownPixelCount;blackPixelCount;areaPercentage,spotCount};
    else
       featureArray(end+1,:)  = {imagename filenameSplit{3} yellowPixelCount brownPixelCount blackPixelCount areaPercentage spotCount1 spotCount2 spotCount3 filenameSplit{4}};
    end
     
end
%save feature array
save('features.mat','featureArray');
%xlswrite('test.xlsx',C,'data','A1');
%fullFileName = 'Banana_Day3.jpg'
%'C:\Users\Ashwini\Desktop\IMG_20181005_194809.jpg'%'C:\Ashwini Documents\MS-2017\Fall-2018\Computer vision\data\images\IMG_20181007_001812.jpg';
