%Normalizes the depth image by setting the minimum value in the depth
%imaage to zero.
% Open the figure and locate graphics objects with specific properties
% using findobj

currentDir = pwd;
baseDir = strrep(currentDir, '\database_v2', '');
raw = [baseDir '\raw_v2'];
% Check if directory exists
if ~isdir(raw)
    errorMessage = sprintf('Error; The following directory does not exist: \n%s', raw);
    uiwait(warndlg(errorMessage));
    return;
end

i = 0;
for k = ['b':'d' 'f':'i' 'k':'l' 'o':'r' 'u':'y']
    for i = 1:10
        FileName = [k int2str(i) '.fig'];
        baseFilePath = fullfile(raw, FileName);
        fprintf(1, 'Accessing figure: %s\n', baseFilePath);
        iTemp1=openfig(baseFilePath);
        iTemp2=findobj(iTemp1,'type','image');
        I=iTemp2.CData;
        
        imshow(I, [0 4000]);
        
        % SEGMENT OUT THE HAND
        %make a copy of the original image
        I2=I;
        
        % Replace pixel value 0 to 4000. This prevents 0 from being the minimum value
        I2((I2<=0))=4000;
        
        % Minus all values in array I2 by the minimum value of itself
        I2=I2-min(min(I2));
        
        % Readjust values above 90 to 4000.
        I2((I2>90)) = 4000;
        
        imshow(I2, [0 90]);
        
        % Save as a new figure
        fprintf(1, 'Saving figure: %s\n', FileName);
        savefig(FileName);
        close;
    end
end
