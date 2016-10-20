
Database = [pwd '\raw_v1'];
% Check if directory exists
if ~isdir(Database)
    errorMessage = sprintf('Error; The following directory does not exist: \n%s', Database);
    uiwait(warndlg(errorMessage));
    return;
end

i = 0;
S = [];
for k = 'd'
    for i = 1:6
        FileName = [k int2str(i) '.fig'];
        baseFilePath = fullfile(Database, FileName);
        fprintf(1, 'Accessing figure: %s\n', baseFilePath);
        iTemp1=openfig(baseFilePath, 'invisible');
        iTemp2=findobj(iTemp1,'type','image');
        I=iTemp2.CData;
        S = [S I];
    end
end

[height,width] = size(S);
n = 0;
figure;
for imgPos = 1:(640-1):(width - 640 -1)
    n = n + 1;
    newImg = S(:,imgPos:imgPos+640-1);
    sub = subaxis(3,3,n, 'Spacing', 0, 'Padding', 0, 'Margin', 0);
    imshow(newImg, [0 4000]);
end