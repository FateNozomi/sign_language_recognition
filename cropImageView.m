inputFig = 'g7.fig';
unknownSample = fullfile([pwd '\sample_v1'], inputFig);
imTemp1=openfig(unknownSample,'invisible');
fprintf(1, '\nIdentifiying unknown sample %s\n', unknownSample);
imTemp2=findobj(imTemp1,'type','image');
I=imTemp2.CData;

% SEGMENT OUT THE HAND
%make a copy of the original image
I2=I;

% Replace pixel value 0 to 4000. This prevents 0 from being the minimum value
I2((I2<=0))=4000;

% minI2 = min(min(I2));
% I2(I2<minI2)=4000;
% figure;imshow(I2, [0 4000]);

% Minus all values in array I2 by the minimum value of itself
I2=I2-min(min(I2));

% Readjust values above 70 to 4000.
% I2(I2>minI2+80)=4000;
I2((I2>80))=4000;

I = I2;

% figure,imshow(I, [0 4000]);

%Crop Unknown Sample Image
%
% size(I,1) returns the number of rows in array I (480)
iRows = double(size(I,1));
% size(I,2) returns the number of columns in array I (640)
iColumns = double(size(I,2));

%Get the first non 4000*640 row
% I is a 480 by 640 array
rowPos = 0; %Initialize row position variable
for m = 1 : iRows;
    % Get the m(th) row value of the first column
    mthRowVal = double(I(m,1));
    
    % double is needed as the value of  exceeds 2^16
    mRC = mthRowVal*iColumns;
    
    % Row position
    rowPos = rowPos + 1;
    % Break if the (R)th mRow exeeds the sum of m(th) row
    if mRC > sum(I(m,:))
        break
    end
end

I2 = I(rowPos:rowPos+129,:);
% figure; imshow(I2, [0 4000]);

% Get the first non 4000*480 column from the left
%
% size(I2,1) returns the number of rows in array I2 (130)
iRows2 = double(size(I2,1));
leftColumnPos = 0; %Initialize column position variable
% size(I,1) returns the number of rows in array I (480)
for n = 1 : iColumns;
    % Get the n(th) column value of the first row
    nthColumnVal = double(I2(1,n));
    
    % double is needed as value exceeds 2^16
    mRC = nthColumnVal*iRows2;
    
    % Column position
    leftColumnPos = leftColumnPos + 1;
    
    % Break if the (c)th nColumn exeeds the sum of n(th) column
    if mRC > sum(I2(:,n))
        break
    end
end

% Get the first non 4000*480 column from the right
%
rightColumnPos = size(I2,2);
% size(I,1) returns the number of rows in array I (480)
for n = iColumns:-1:1
    % Get the n(th) column value of the first row
    nthColumnVal = double(I2(1,n));
    
    % double is needed as value exceeds 2^16
    % Get the nthColumnVar multiply with iColumns
    mRC = nthColumnVal*iRows2;
    
    % Column position
    rightColumnPos = rightColumnPos - 1;
    
    % Break if the (n)th mRC exeeds the sum of n(th) column
    if mRC > sum(I2(:,n))
        break
    end
end

figure,imshow(I, [0 80]);
hold on
rectangle('Position',[leftColumnPos,rowPos,rightColumnPos - leftColumnPos, 150],'EdgeColor','r', 'LineWidth', 1)


Z = I2(:,leftColumnPos:rightColumnPos);
Z = imresize(Z, [100 50]);
figure,imshow(Z, [0 80]);
hold on
rectangle('Position',[1,1,49,99],'EdgeColor','k', 'LineWidth', 1)