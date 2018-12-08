%Load Features
clc;
clear all;
close all;
cd('C:\Users\Ashwini\Documents\MATLAB\BananaDataset\Banana-Images');
features=load('features.mat');
fontSize = 20;
featuresArray={};
featuresArray=features.featureArray;
baseFileName='';

cd('C:\Users\Ashwini\Documents\MATLAB\BananaDataset');
%select image
message = sprintf('Pick Banana Image');
reply2 = questdlg(message, 'Select Image', 'Demo','Demo');
start_path = fullfile(pwd);
%folder = fullfile(matlabroot, '\toolbox\images\imdemos');
if ~exist(start_path, 'dir')
			folder = pwd; 
end 
cd(start_path); 

% Browse for the image file. 
[baseFileName, folder] = uigetfile('*.*', 'Specify an image file'); 
fullImageFileName = fullfile(folder, baseFileName); 
% Set current folder back to the original one. 
cd(start_path);
selectedImage = 'My own image';

% Check to see that the image exists.  (Mainly to check on the demo images.)
if ~exist(fullImageFileName, 'file')
		message = sprintf('This file does not exist:\n%s', fullImageFileName);
		WarnUser(message);
		return;
end

%read image file
[rgbImage,storedColorMap] = imread(fullImageFileName); 
%rgbImage= imresize(rgbImage, [227 227]);
%remove background
[bw, rgb]=BGMask(rgbImage);
[bw1,rgb1]=createMask(rgbImage);
[filepath,filename,ext] = fileparts(baseFileName);
%save rgb part of image
rgbImagePart=strcat(start_path,'\processed\',filename,'_WBG_','_Test' ,'.jpg');
imwrite(rgb, rgbImagePart);
% bwImagePart=strcat(topLevelFolder,'\processed\',filename,'_BW_','_Test','.jpg');
%imwrite(bw, bwImagePart);
%Detect color pixels based on hue values.
imageColorLayer = colorDetectionByHue(rgb1); 
yellow=imageColorLayer.yellow;
yellowPixelCount=sum(yellow(:));
%brown pixel count
brown=imageColorLayer.brown;
brownPixelCount=sum(brown(:));
%black pixel count
black=imageColorLayer.black;
blackPixelCount=sum(black(:));
%spot area percentage
areaPercentage=detectSpoiledArea(rgb1);
%count spots on image by watershed
spotCount1=countSpotsByWatershed(bw);
%count spots on image using V-value threshold
spotCount2=countSpotsByVThreshold(rgbImagePart);
%to store sample difference and avergaes
samplediffvalues={};
avgOfdiff={'avg'};


%compare features with extracted features
 for rowNum = 2:size(featuresArray,1)
    % To build up binary string from left to right
    % Iterate over each column
    yellowPixelDiff=0;
    brownPixelDiff=0;
    blackPixelDiff=0;
    for colNum = 2:size(featuresArray,2)
       % b{rowNum,colNum}
       %to get day details
       if(colNum == 2)
           day=featuresArray{rowNum,colNum};
       elseif(colNum == 3) %compare yellow pixel count from sample to test
           yellowPixelsSample=featuresArray{rowNum,colNum};
           if(yellowPixelsSample > yellowPixelCount)
              yellowPixelDiff=yellowPixelsSample - yellowPixelCount;
           else
               yellowPixelDiff=yellowPixelCount - yellowPixelsSample;
           end
               
       elseif(colNum == 4) %compare brown pixel count from sample to test
           brownPixelsSample=featuresArray{rowNum,colNum};
           if(brownPixelsSample > brownPixelCount)
              brownPixelDiff=brownPixelsSample - brownPixelCount;
           else
               brownPixelDiff=brownPixelCount - brownPixelsSample;
           end
           
       elseif(colNum ==5)%compare black pixel count from sample to test
            blackPixelsSample=featuresArray{rowNum,colNum};
           if(blackPixelsSample > blackPixelCount)
              blackPixelDiff=blackPixelsSample - blackPixelCount;
           else
               blackPixelDiff=blackPixelCount - blackPixelsSample;
           end
       elseif(colNum ==6) %compare spoiled area percentage from sample to test
           spoiledAreaSample=featuresArray{rowNum,colNum};
           if(spoiledAreaSample > areaPercentage)
           spoiledAreaDiff=spoiledAreaSample - areaPercentage;
           else
           spoiledAreaDiff=areaPercentage - spoiledAreaSample;
           end
       elseif(colNum == 7)%compare count of spots by watershed method of test with sample
           spotCountByWatershedSample=featuresArray{rowNum,colNum};
           if(spotCountByWatershedSample > spotCount1)
            spotCountByWatersheddiff=spotCountByWatershedSample-spotCount1;
           else
            spotCountByWatersheddiff=spotCount1-spotCountByWatershedSample;
           end
       elseif(colNum == 8) %comapre count of spots by v-value method of test with sample
           spotCountByVSample=featuresArray{rowNum,colNum}; 
           if(spotCountByVSample > spotCount2)
            spotCountByVdiff=spotCountByVSample-spotCount2;
           else
            spotCountByVdiff=spotCount2-spotCountByVSample;
           end
       elseif(colNum == 10)
           lastedday=featuresArray{rowNum,colNum}; 
       end
       
       %average the differences in samples and test image
      % avgDiffValue= round(yellowPixelDiff+brownPixelDiff+blackPixelDiff+spoiledAreaDiff+spotCountByWatersheddiff+spotCountByVdiff)/6;
       
        % disp(b{rowNum,colNum});
       % disp(colNum);
    end
     avgDiffValue= round(yellowPixelDiff+brownPixelDiff+blackPixelDiff+spoiledAreaDiff+spotCountByWatersheddiff+spotCountByVdiff)/6;
     if(rowNum ==2)
         %avgOfdiff={featuresArray{rowNum,1},day,avgDiffValue};
         avgOfdiff={avgDiffValue};
         samplediffvalues = {'Day','YellowPixels','BrownPixels','BlackPixels','SpoiledArea','SpotCountByWatershed','SpotCountByVThreshold','avg','Lastedtill'; day yellowPixelDiff brownPixelDiff blackPixelDiff spoiledAreaDiff spotCountByWatersheddiff spotCountByVdiff avgDiffValue lastedday};
       else
         samplediffvalues(end+1,:)= {day yellowPixelDiff brownPixelDiff blackPixelDiff spoiledAreaDiff spotCountByWatersheddiff spotCountByVdiff avgDiffValue lastedday};
         avgOfdiff(end+1,:)={avgDiffValue};
     end
 end
minVal=min(cell2mat(avgOfdiff));
for i = 2:size(samplediffvalues,1)
  if(samplediffvalues{i,8} == minVal)
      %day= strcat('day', samplediffvalues{i,1});
      day= samplediffvalues{i,1};
      sampleday= str2double(samplediffvalues{i,1}) ;
      lastday=str2double(samplediffvalues{i,9});
      lastedtill= (lastday(1))- (sampleday(1));
      break;
  end
end

message = sprintf(strcat('Banana is of ==>',' ', day,' day and will last ==>',num2str(lastedtill),' days'));
%set( message, 'FontSize', 10 );
uiwait(msgbox(message));

% message = sprintf('Pick Banana Image');
% h = msgbox(strcat('Banana is of',day,' and will last for',num2str(lastedtill)),'Banana Shelf Life Prediction');
% set(h, 'position', [95 300 400 95]); %makes box bigger
% % ah = get( h, 'CurrentAxes' );
% % ch = get( ah, 'Children' );
% set( ch, 'FontSize', 12 )


% object_handles = findall(message);
% set( object_handles(6), 'FontSize', 20)
%set(message, 'position', [90 350 1000 90]);
%message = sprintf( strcat('Banana is of',day,' and will last for',last));
%reply2 = questdlg(message, 'Banana Shelf Life','');
% isSix = cellfun(@(x)isequal(x,minVal),avgOfdiff);
% [row,col] = find(isSix);


%day =samplediffvalues{2,col};
 %finalResult = avg(indexOfMin)
 %[minVal, minIndex] = min([samplediffvalues{:}]);
 %[minsize, minidx] = cellfun(@(samplediffvalues) size(samplediffvalues,2), samplediffvalues);
 %[minVal, minIndex] = min(samplediffvalues(:))
%'Image','Day','YellowPixels','BrownPixles','BlackPixles','SpoiledArea','SpotCountByWatershed','SpotCountByVThreshold'