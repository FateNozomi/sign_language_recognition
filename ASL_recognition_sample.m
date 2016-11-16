% ASL_recognition_sample

% Load database.mat if database does not exist
if ~exist('database','var')
    % get 2-D array database
    load('database.mat');
end

% Get databaseOpen and databaseClosed
databaseOpen = database{1};
databaseClosed = database{2};

% Get the number of columns in both database
colDatabaseOpen = size(databaseOpen);
colDatabaseOpen = colDatabaseOpen(2);
colDatabaseClosed = size(databaseClosed);
colDatabaseClosed = colDatabaseClosed(2);

% PCA on both database
[coeff1,score1] = pca(double(databaseOpen));
[coeff2,score2] = pca(double(databaseClosed));

Xcentered1 = score1*coeff1';
PCA_DatabaseOpen = score1'*Xcentered1;

Xcentered2 = score2*coeff2';
PCA_DatabaseClosed = score2'*Xcentered2;


%%% Test unknown sample image
unknownSample = fullfile([pwd '\sample'], 'c11.fig');
fprintf(1, '\nIdentifiying unknown sample %s\n', unknownSample);
HandRightState = 1;
imTemp1 = openfig(unknownSample,'invisible');
imTemp2 = findobj(imTemp1,'type','image');
I = imTemp2.CData;

%%% SEGMENT OUT THE HAND
%%Normalize
% Replace depth value 0 to 4000. This eliminates IR shadow
I((I<=0)) = 4000;
% Minus all values in array I by the minimum value of itself
I = I - min(min(I));
%%Segmentation
% Readjust values above 90 to 4000.
I((I>90)) = 4000;

% Check HandRightState to determine which cropping algorithm to use
if HandRightState == 3
    Z = cropImage_Closed(I);
else
    Z = cropImage_Open(I);
end

figure;imshow(Z, [0 100]);

[irow,icol]=size(Z);
% Reshape a 640-by-480 matrix into a matrix that has only 1 column
Z=reshape(Z,irow*icol,1);
Z=double(Z);
Z=Z-mean(Z);

% Check HandRightState to determine which database to use
if HandRightState == 3
    PCA_DatabaseClosedUnknown = score2'*Z;
    
    for i = 1:colDatabaseClosed
        difference(i) = sum(abs(PCA_DatabaseClosedUnknown-PCA_DatabaseClosed(:,i)));
    end
    
    finalDiff=[];
    for i = 1:10:colDatabaseClosed
        temp2 = sum(difference(:,i:i+9));
        finalDiff = [finalDiff temp2];
    end
    
    finalDiff
    
    minDiffPos = find(finalDiff==min(finalDiff));
    
    alphabetList = ['A' 'E' 'M' 'N' 'S' 'T'];
    minDiff = finalDiff(:,minDiffPos);
    alphabetSign = alphabetList(:,minDiffPos)
    
else
    PCA_DatabaseOpenUnknown = score1'*Z;
    
    for i = 1:colDatabaseOpen
        difference(i) = sum(abs(PCA_DatabaseOpenUnknown-PCA_DatabaseOpen(:,i)));
    end
    
    finalDiff=[];
    for i = 1:10:colDatabaseOpen
        temp2 = sum(difference(:,i:i+9));
        finalDiff = [finalDiff temp2];
    end
    
    finalDiff
    
    minDiffPos = find(finalDiff==min(finalDiff));
    
    alphabetList = ['B':'D' 'F':'I' 'K':'L' 'O':'R' 'U':'Y'];
    minDiff = finalDiff(:,minDiffPos);
    alphabetSign = alphabetList(:,minDiffPos)
end