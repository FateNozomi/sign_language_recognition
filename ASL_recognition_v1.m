function alphabetSign = ASL_recognition(HandRightState, inputImage)
%ASL_recognition This recognition algorithm takes in 2 variables: HandRightState and sample image
%

load('features.mat');

%%% SEGMENT OUT THE HAND
I = inputImage;

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
    featureUnknown = coeff2'*Z;
    
    for i = 1:length(featuresClosed)
        d(i) = norm(featureUnknown - featuresClosed(:,i));
    end
    
    [distance,index] = min(d);
    
    alphabetList = ['A' 'E' 'M' 'N' 'O' 'S' 'T'];
    alphabetListClosed = [];
    for i = 1:length(alphabetList);
        alphabetListTemp = repmat(alphabetList(i),1,10);
        alphabetListClosed = [alphabetListClosed alphabetListTemp];
    end
    alphabetSign = alphabetListClosed(:,index);
    
else
    featureUnknown = coeff1'*Z;
    
    for i = 1:length(featuresOpen)
        d(i) = norm(featureUnknown - featuresOpen(:,i));
    end
    
    [distance,index] = min(d);
    
    alphabetList = ['B':'D' 'E':'I' 'K':'L' 'O':'R' 'U':'Y'];
    alphabetListOpen = [];
    for i = 1:length(alphabetList);
        alphabetListTemp = repmat(alphabetList(i),1,10);
        alphabetListOpen = [alphabetListOpen alphabetListTemp];
    end
    alphabetSign = alphabetListOpen(:,index);
end