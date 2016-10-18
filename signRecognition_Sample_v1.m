% PCA v2

% Assign directory \database, pwd identifies current folder
Database = [pwd '\database_v1'];
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

if ~exist('S','var')
    % get 2-D array database
    S = getDatabase_v1;
end

%mean image;
m=mean(S,2);   %obtains the mean of each row instead of each column
tmimg=double(m); %

M=length(reqFiles);
dbx=[];
for i=1:M
    temp=double(S(:,i))-tmimg;
    dbx=[dbx temp];
end

[eigval, FD]=pca(dbx);
w=FD'*dbx;

%%%%%%%%%%%%%%%%%%%%%%%%%
%  input unknown image  %

unknownSample = fullfile([pwd '\sample_v1'], 'b7.fig');
imTemp1=openfig(unknownSample,'invisible');
fprintf(1, '\nIdentifiying unknown sample %s\n', unknownSample);
imTemp2=findobj(imTemp1,'type','image');
I=imTemp2.CData;

% SEGMENT OUT THE HAND
%make a copy of the original image
I2=I;

% Replace pixel value 0 to 4000. This prevents 0 from being the minimum value
I2((I2<=0))=4000;

% Minus all values in array I2 by the minimum value of itself
I2=I2-min(min(I2));

% Readjust values above 70 to 4000.
I2((I2>80))=4000;

I = I2;

Z= cropImage(I);
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
finalDiff=[];
for i=1:6:length(reqFiles)
    difference = sum(diff(:,i:i+5));
    finalDiff = [finalDiff difference];
end

finalDiff

minDiffPos = find(finalDiff==min(finalDiff));

alphabetList = ['A':'I' 'K':'Y'];
minDiff = finalDiff(:,minDiffPos);
alphabetSign = alphabetList(:,minDiffPos)