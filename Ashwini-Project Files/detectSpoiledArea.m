function output = detectSpoiledArea(rgbImage)

% Convert to HSV color space
hsv = rgb2hsv(rgbImage);
h = hsv(:, :, 1);
s = hsv(:, :, 2);
v = hsv(:, :, 3);
% Find the black.  It's V will be less than, say .1
blackPixels = v < 0.6; %.1;%0.59;

background = xor(blackPixels, imclearborder(blackPixels));

h(background) = 0;
v(background) = 0;
v(background) = 0;

[pixelCount, grayLevels] = hist(h(:), 100);
% Suppress the big spike at zero gray levels due to the background.
pixelCount(1) = 0;

% Call anything with a hue of between 0.15 and 0.5 "healthy".
healthyImage = (h > 0.105) & (h < 0.9);
% Call anything else (that is not background) "diseased."
spoiledImage = ~healthyImage & ~background;

% Compute the diseased area fraction
entirePixels = sum(~background(:));
areaFraction = sum(spoiledImage(:)) / entirePixels;
output=areaFraction;




end