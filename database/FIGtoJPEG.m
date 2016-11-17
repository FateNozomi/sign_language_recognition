%Convert RGB to JPEG
% http://matlab.wikia.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F

rgb = pwd;
% Check if directory exists
if ~isdir(rgb)
    errorMessage = sprintf('Error; The following directory does not exist: \n%s', rgb);
    uiwait(warndlg(errorMessage));
    return;
end

% Select files using a specified pattern
filePattern = fullfile(rgb, '*.fig');
% Lists out all required files which follows the pattern
reqFiles = dir(filePattern);

for k = 1:length(reqFiles)
    %Index into the structure to access a particular item from reqFiles
    baseFileName = reqFiles(k).name;
    %fullfile returns a string containing the full path to the file
    baseFilePath = fullfile(rgb, baseFileName);
    fprintf(1, 'Accessing figure: %s\n', baseFilePath);
    rgbImage=openfig(baseFilePath);
    set(gca,'position',[0 0 1 1],'units','normalized')
    %Remove .fig in baseFileName
    fileName = strrep(baseFileName, '.fig', '');
    saveas(rgbImage,[fileName '.jpg']);
    close;
end