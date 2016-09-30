%%%%%%%%%%%%%%%%%%%%%%%%%
%  input unknown image  %

unknownSample = fullfile([pwd '\sample'], 'p4.fig');
imTemp1=openfig(unknownSample,'invisible');
fprintf(1, '\nIdentifiying unknown sample %s\n', unknownSample);
imTemp2=findobj(imTemp1,'type','image');
I=imTemp2.CData;

figure;imshow(I, [0 4000]);

%SEGMENT OUT THE HAND
% make a copy of the original image
I2=I;

% Replace pixel value 0 to 4000. This prevents 0 from being the minimum value
I2((I2<=0))=4000;


% Minus all values in array I2 by the minimum value of itself
I2=I2-min(min(I2));

% Readjust values above 80 to 4000.
I2((I2>80))=4000;

imshow(I2, [0 4000]);

I = I2;


%Crop Unknown Sample Image

%Get the first non 4000*640 row
% I is a 480 by 640 array
R = 0;
% size(I,1) returns the number of rows in array I (480)
for m = 1 : size(I,1);
    % Get the m(th) row value of the first column
    Var1 = double(I(m,1));
    % size(I,2) returns the number of columns in array I (640)
    Var2 = double(size(I,2));
    % double is needed as value exceeds 2^16
    mRow = Var1*Var2;
    
    % Row position
    R = R + 1;
    % Break if the (R)th mRow exeeds the sum of m(th) row
    if mRow > sum(I(m,:))
        break
    end
end

% Get the first non 4000*480 column
%
C = 0;
% size(I,1) returns the number of rows in array I (480)
for n = 1 : size(I,2);
    % Get the n(th) column value of the first row
    Var1 = double(I(1,n));
    % size(I,1) returns the number of rows in array I (480)
    Var2 = double(size(I,1));
    
    % double is needed as value exceeds 2^16
    nColumn = Var1*Var2;
    
    % Column position
    C = C + 1;
    
    % Break if the (c)th nColumn exeeds the sum of n(th) column
    if nColumn > sum(I(:,n))
        break
    end
end
Z = I(R:R+119,C:C+79);
figure; imshow(Z, [0 4000]);