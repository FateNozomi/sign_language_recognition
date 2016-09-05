%Normalizes the depth image by setting the minimum value in the depth
%imaage to zero.
% Open the figure and locate graphics objects with specific properties
% using findobj
iTemp1=openfig('a1.fig', 'invisible');
iTemp2=findobj(iTemp1,'type','image');
I=iTemp2.CData;

% figure;imshow(I);
% figure;imshow(I,[min(min(I)) max(max(I))]);
figure;imshow(I, [0 4000]);

% SEGMENT OUT THE HAND
%make a copy of the original image
I2=I;

% Replace pixel value 0 to 4000. This prevents 0 from being the minimum value
I2((I2<=0))=4000;

% Minus all values in array I2 by the minimum value of itself
I2=I2-min(min(I2));

% Readjust values above 500 to 4000.
I2((I2>500))=4000;

figure;imshow(I2, [0 4000]);

% Save as a new figure
savefig('a1_new.fig');
