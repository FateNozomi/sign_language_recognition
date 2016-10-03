
%% Kinect adaptor and devices
info = imaqhwinfo('kinect');

%% create videoinput Object for Color Stream
if ~exist('colorVid','var')
    info.DeviceInfo(1);
    colorVid = videoinput('kinect',1,'RGB_640x480');
    preview(colorVid);
end

% RGBImage = getsnapshot(colorVid);
% imshow(RGBImage);

%% Videoinput Object for Depth Stream
if ~exist('depthVid','var')
    info.DeviceInfo(2);
    depthVid = videoinput ('kinect',2,'Depth_640x480');
    preview(depthVid);
end

%% Save png and fig
i = 0;
for k = 'z'
    for i = 1:4
        %input('Press Enter to proceed\n');
        FileName = [k int2str(i)];
        fprintf(1, 'Capturing %s in 3 seconds\n', FileName);
        pause(3);
        RGBImage = getsnapshot(colorVid);
        imshow(RGBImage);
        savefig(['RGB' FileName]);
        depthImage = getsnapshot(depthVid);
        imshow(depthImage, [0 4000])
        savefig(FileName);
        fprintf(1, 'Saving figure: %s\n', FileName);
    end
end
