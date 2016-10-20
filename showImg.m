
Database = [pwd '\raw_v1'];
% Check if directory exists
if ~isdir(Database)
    errorMessage = sprintf('Error; The following directory does not exist: \n%s', Database);
    uiwait(warndlg(errorMessage));
    return;
end

i = 0;
S = [];
for k = 'g'
    for i = 1:6
        FileName = [k int2str(i) '.fig'];
        baseFilePath = fullfile(Database, FileName);
        fprintf(1, 'Accessing figure: %s\n', baseFilePath);
        iTemp1=openfig(baseFilePath, 'invisible');
        iTemp2=findobj(iTemp1,'type','image');
        I=iTemp2.CData;

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
        I = cropImage(I);
        S = [S I];
    end
end

[height,width] = size(S);
n = 0;
figure;
for imgPos = 1:50:width
    n = n + 1;
    newImg = S(:,imgPos:imgPos+50-1);
    sub = subaxis(3,3,n, 'Spacing', 0, 'Padding', 0, 'Margin', 0);
    imshow(newImg, [0 80]);
end