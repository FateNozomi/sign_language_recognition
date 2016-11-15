% ASL_recognition_sample

% Call getDatabase_v2_1 if database does not exist
if ~exist('database','var')
    % get 2-D array database
    database = getDatabase_v2_1;
end

% compute the mean of each column in database
m = mean(database,1);
mDatabase = double(m);

% Get the number of columns in database
cDatabase = size(database);
cDatabase = cDatabase(2);

databaseAdjust = [];
for i = 1:cDatabase
    temp = double(database(:,i))-mDatabase(i);
    databaseAdjust = [databaseAdjust temp];
end

[coeff,score] = pca(double(database));

Xcentered = score*coeff';
W = score'*Xcentered;

% Test unknown sample image
unknownSample = fullfile([pwd '\sample_v2_1'], 't11.fig');
fprintf(1, '\nIdentifiying unknown sample %s\n', unknownSample);
imTemp1 = openfig(unknownSample,'invisible');
imTemp2 = findobj(imTemp1,'type','image');
I = imTemp2.CData;

% SEGMENT OUT THE HAND
% make a copy of the original image
I2 = I;

% Replace pixel value 0 to 4000. This prevents 0 from being the minimum value
I2((I2<=0)) = 4000;

% Minus all values in array I2 by the minimum value of itself
I2 = I2 - min(min(I2));

% Readjust values above 80 to 4000.
I2((I2>90)) = 4000;

I = I2;

Z = cropImage_v2_1(I);

figure;imshow(Z, [0 100]);

[irow,icol]=size(Z);
% Reshape a 640-by-480 matrix into a matrix that has only 1 column
Z=reshape(Z,irow*icol,1);
Z=double(Z);
Z=Z-mean(Z);

score2 = score'*Z;

for i = 1:cDatabase
    difference(i) = sum(abs(score2-W(:,i)));
end

finalDiff=[];
for i = 1:10:cDatabase;
    temp2 = sum(difference(:,i:i+9));
    finalDiff = [finalDiff temp2];
end

finalDiff

minDiffPos = find(finalDiff==min(finalDiff));

alphabetList = ['A' 'E' 'M' 'N' 'S' 'T'];
minDiff = finalDiff(:,minDiffPos);
alphabetSign = alphabetList(:,minDiffPos)