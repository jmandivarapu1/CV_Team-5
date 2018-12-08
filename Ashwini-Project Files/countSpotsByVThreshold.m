function output = countSpotsByVThreshold(filename)
% Get the dimensions of the image.  numberOfColorBands should be = 3.
rgbImage=imread(filename);
[rows columns numberOfColorBands] = size(rgbImage);
% Display the original color image.
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);
spots = blueChannel < 70.5;%15.5; %70.5;
spots = imclearborder(spots);
% Fill holes
spots = imfill(spots, 'holes');
%imshow(spots, []);
%title('Final Spots Image', 'FontSize', fontSize);
% Count them
[labeledImage numberOfSpots] = bwlabel(spots);
output=numberOfSpots;
end