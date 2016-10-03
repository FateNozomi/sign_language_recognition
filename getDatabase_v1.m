function S = getDatabase()
%GETDATABASE assigns all .figs into a 2-D array
% function getDatabase creates a 2-D array by arranging each .fig in the
% database folder. It reshapes each 640-by-480 matrix into a matrix that 
% has only 1 column.

% Building Database
% Get path to Database directory
% The pwd command displays the MATLAB® current folder. Therefore, please
% navigate to the root directory of this file before running this script.
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
% Define empty matrix S, prevents "Undefined function or variable." error
S=[];
for k = 1 : length(reqFiles)
    %Index into the structure to access a particular item from reqFiles
    baseFileName = reqFiles(k).name;
    %fullfile returns a string containing the full path to the file
    baseFilePath = fullfile(Database, baseFileName);
    fprintf(1, 'Accessing %s\n', baseFilePath);
    imTemp1=openfig(baseFilePath,'invisible');
    imTemp2=findobj(imTemp1,'type','image');
    I=imTemp2.CData;
    
    Z = cropImage(I);
    [irow,icol]=size(Z);
    % Reshape a 640-by-480 matrix into a matrix that has only 1 column
    Z=reshape(Z,irow*icol,1);
    S=[S Z];
end