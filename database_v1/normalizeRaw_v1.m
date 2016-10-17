%Normalizes the depth image by setting the minimum value in the depth
%imaage to zero.
% Open the figure and locate graphics objects with specific properties
% using findobj

currentDir = pwd;
baseDir = strrep(currentDir, '\database_v1', '');
raw = [baseDir '\raw_v1'];
% Check if directory exists
if ~isdir(raw)
    errorMessage = sprintf('Error; The following directory does not exist: \n%s', raw);
    uiwait(warndlg(errorMessage));
    return;
end

i = 0;
for k = 'z'
    for i = 1:6
        FileName = [k int2str(i) '.fig'];
        baseFilePath = fullfile(raw, FileName);
        fprintf(1, 'Accessing figure: %s\n', baseFilePath);
        iTemp1=openfig(baseFilePath);
        iTemp2=findobj(iTemp1,'type','image');
        I=iTemp2.CData;
        
        % figure;imshow(I);
        % figure;imshow(I,[min(min(I)) max(max(I))]);
        imshow(I, [0 4000]);
        
        % SEGMENT OUT THE HAND
        %make a copy of the original image
        I2=I;
        
        % Replace pixel value 0 to 4000. This prevents 0 from being the minimum value
        I2((I2<=0))=4000;
        
        % Minus all values in array I2 by the minimum value of itself
        I2=I2-min(min(I2));
        
        % Readjust values above 70 to 4000.
        I2((I2>80))=4000;
        
        imshow(I2, [0 4000]);
        
        % Save as a new figure
        fprintf(1, 'Saving figure: %s\n', FileName);
        savefig(FileName);
    end
end
