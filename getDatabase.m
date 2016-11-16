function S = getDatabase()
%GETDATABASE assigns all .figs into a 2-D array
% function getDatabase creates a 2-D array by arranging each .fig in the
% database folder. It reshapes each 640-by-480 matrix into a matrix that 
% has only 1 column.

% Building Database
% Get path to Database directory
% The pwd command displays the MATLAB® current folder. Therefore, please
% navigate to the root directory of this file before running this script.
raw = [pwd '\raw'];
% Check if directory exists
if ~isdir(raw)
    errorMessage = sprintf('Error; The following directory does not exist: \n%s', raw);
    uiwait(warndlg(errorMessage));
    return;
end
% Select files using a specified pattern
filePattern = fullfile(raw, '*.fig');
% Lists out all required files which follows the pattern
reqFiles = dir(filePattern);
% Define empty matrix S, prevents "Undefined function or variable." error
databaseStateOpen = [];
state = [11:40 51:110 131:170 191:240];
for k = 1 : 180
    %Index into the structure to access a particular item from reqFiles
    baseFileName = reqFiles(state(k)).name;
    %fullfile returns a string containing the full path to the file
    baseFilePath = fullfile(raw, baseFileName);
    fprintf(1, 'Accessing %s\n', baseFilePath);
    imTemp1=openfig(baseFilePath,'invisible');
    imTemp2=findobj(imTemp1,'type','image');
    % Store depth image data into I
    I=imTemp2.CData;
    
    %%% SEGMENT OUT THE HAND
    %%Normalize
    % Replace depth value 0 to 4000. This eliminates IR shadow
    I((I<=0)) = 4000;
    % Minus all values in array I by the minimum value of itself
    I = I - min(min(I));
    %%Segmentation
    % Readjust values above 90 to 4000.
    I((I>90)) = 4000;
    
    Z = cropImage_Open(I);
    
    [irow,icol] = size(Z);
    
    % Reshape a 80-by-50 matrix into a matrix that has only 1 column
    Z=reshape(Z,irow*icol,1);
    databaseStateOpen = [databaseStateOpen Z];
end

% For ['A' 'E' 'M' 'N' 'S' 'T']
databaseStateClosed = [];
state3 = [1:10 41:50 111:130 171:190];
for k = 1 : 60
    %Index into the structure to access a particular item from reqFiles
    baseFileName = reqFiles(state3(k)).name;
    %fullfile returns a string containing the full path to the file
    baseFilePath = fullfile(raw, baseFileName);
    fprintf(1, 'Accessing %s\n', baseFilePath);
    imTemp1=openfig(baseFilePath,'invisible');
    imTemp2=findobj(imTemp1,'type','image');
    % Store depth image data into I
    I=imTemp2.CData;
    
    %%% SEGMENT OUT THE HAND
    %%Normalize
    % Replace depth value 0 to 4000. This eliminates IR shadow
    I((I<=0)) = 4000;
    % Minus all values in array I by the minimum value of itself
    I = I - min(min(I));
    %%Segmentation
    % Readjust values above 90 to 4000.
    I((I>90)) = 4000;
    
    Z = cropImage_Closed(I);
    
    [irow,icol]=size(Z);
    
    % Reshape a 40-by-50 matrix into a matrix that has only 1 column
    Z=reshape(Z,irow*icol,1);
    databaseStateClosed = [databaseStateClosed Z];
end

S = {databaseStateOpen databaseStateClosed};
save('database','S');
