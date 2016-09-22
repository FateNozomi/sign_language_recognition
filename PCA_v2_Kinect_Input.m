%PCA v2

if ~exist('S','var')
    % get 2-D array database
S = getDatabase;
end
%%
%mean image;
m=mean(S,2);   %obtains the mean of each row instead of each column
tmimg=double(m);


Database = [pwd '\database'];
% Check if directory exists
if ~isdir(Database)
    errorMessage = sprintf('Error; The following directory does not exist: \n%s', Database);
    uiwait(warndlg(errorMessage));
    return;
end
% Select files using a specified pattern
filePattern = fullfile(Database, '*.fig');
% Lists out all required files which follows the pattern
reqFiles = dir(filePattern);


M = length(reqFiles);
dbx=[];
for i=1:M
    temp=double(S(:,i))-tmimg;
    dbx=[dbx temp];
end

[eigval, FD]=pca(dbx);
w=FD'*dbx;

%%%%%%%%%%%%%%%%%%%%%%%%%
%  input unknown image  %

% unknownSample = fullfile([pwd '\Database\Sample'], 'a4.fig');
% imTemp1=openfig(unknownSample,'invisible');
% fprintf(1, '\nIdentifiying unknown sample %s\n', unknownSample);
% imTemp2=findobj(imTemp1,'type','image');
% I=imTemp2.CData;
fprintf(1, '\nSnapshot in 3 seconds\n');
pause(3);
fprintf(1, '\nIdentifiying unknown sample\n');
depthVid = videoinput ('kinect',2,'Depth_640x480');

I1 = getsnapshot(depthVid);
%make a copy of the original image
I=I1;
%make all zeroes to be 4000
I(I<1)=4000;
figure;imshow(I, [0 4000]);
%make pixel more than min+50 to become 0
offset=min(min(I))+100;
I(I>offset)=0;

%make all zeroes to be 4000
I(I<1)=4000;

%offset all values by the minimum value
I=I-min(min(I));

figure;imshow(I, [0 4000]);

% Crop Unknown Sample Image
    R = 0;
    for m = 1 : size(I,1); %Row 1 to 480 (I=480x640)
        Var1 = double(I(m,1));
        Var2 = double(size(I,2));
        mRow = Var1*Var2;
        R = R + 1;
        if mRow > sum(I(m,:))
            break
        end
    end
    
    C = 0;
    for n = 1 : size(I,2); % Column 1 to 640 (I=480x640)
        Var1 = double(I(n,1));
        Var2 = double(size(I,1));
        nRow = Var1*Var2;
        C = C + 1;
        if nRow > sum(I(:,n))
            break
        end
    end
    Z = I(R:R+119,C:C+79);
    [irow,icol]=size(Z);
    % Reshape a 640-by-480 matrix into a matrix that has only 1 column
    Z=reshape(Z,irow*icol,1);
    S2=double(Z)-tmimg;
    
    
    wu=FD'*S2;

for i=1:M
    diff(i)=sum(abs(wu-w(:,i)));
end
%find(diff==min(diff))
%diff
%Recog [A B C]
finalDiff2=[];
for i=1:3:length(reqFiles)
    difference = sum(diff(:,i:i+2));
    finalDiff2 = [finalDiff2 difference];
end

finalDiff2
%finalDiff = [sum(diff(:,1:3)) sum(diff(:,4:6)) sum(diff(:,7:9))]
minDiffPos = find(finalDiff2==min(finalDiff2));

alphabetList = ['A':'I' 'K':'Y'];
minDiff = finalDiff2(:,minDiffPos);
alphabetSign = alphabetList(:,minDiffPos)