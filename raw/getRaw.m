
%% Kinect adaptor and devices
info = imaqhwinfo('kinect');

%% create videoinput Object for Color Stream
% info.DeviceInfo(1)
% colorVid = videoinput('kinect',1,'RGB_640x480');
% preview(colorVid);
%
% RGBImage = getsnapshot(colorVid);
% imshow(RGBImage);

%% Videoinput Object for Depth Stream
info.DeviceInfo(2)
depthVid = videoinput ('kinect',2,'Depth_640x480');
preview(depthVid);

i = 0;
for k = 'z'
    for i = 1:4
        %input('Press Enter to proceed\n');
        FileName = [k int2str(i)];
        disp('Press a key !')
        fprintf(1, 'Capturing %s in 5 seconds\n', FileName);
        pause(5);
        depthImage = getsnapshot(depthVid);
        imshow(depthImage, [0 4000])
        savefig(FileName);
        fprintf(1, 'Saving figure: %s\n', FileName);
    end
end
