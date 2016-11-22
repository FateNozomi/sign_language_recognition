%Hand Tracking
imaqreset

% Create color and depth kinect videoinput objects.
colorVid = videoinput('kinect', 1);
depthVid = videoinput('kinect', 2);

% Look at the device-specific properties on the depth source device,
% which is the depth sensor on the Kinect V2.
% Set 'EnableBodyTracking' to on, so that the depth sensor will
% return body tracking metadata along with the depth frame.
depthSource = getselectedsource(depthVid);
depthSource.EnableBodyTracking = 'on';

% Set triggerconfig to manual and repeat inf
triggerconfig(depthVid, 'manual');
depthVid.FramesPerTrigger = 1;
depthVid.TriggerRepeat = inf;
triggerconfig(colorVid, 'manual');
colorVid.FramesPerTrigger = 1;
colorVid.TriggerRepeat = inf;

% Start the depth and color acquisition objects.
% This begins acquisition, but does not start logging of acquired data.
pause(5);
start([depthVid colorVid]);

% Start handle image variable
% Initialize snapshotCounter variable
himg = figure(1);
snapshotCounter = 0;

% Marker colors for up to 6 bodies.
colors = ['r';'g';'b';'c';'y';'m'];

% Initialize save counter
i = 0;

while ishandle(himg)
    trigger(depthVid);
    trigger(colorVid);
    
    % Get images and metadata from the color and depth device objects.
    [colorImg] = getdata(colorVid);
    [depthMap, ~, depthMetaData] = getdata(depthVid);
    
    % Find the indexes of the tracked bodies.
    anyBodiesTracked = any(depthMetaData.IsBodyTracked ~= 0);
    trackedBodies = find(depthMetaData.IsBodyTracked);
    
    % Find number of Skeletons tracked.
    nBodies = length(trackedBodies);
    
    figure(1);
    imshow(depthMap, [0 4096]);
    
    if (trackedBodies ~= 0)
        rightHand = depthMetaData.DepthJointIndices(12,:,trackedBodies);
        rightThumb = depthMetaData.DepthJointIndices(25,:,trackedBodies);
        
        % Get right hand depth value for all tracked bodies
        rightHandDepthMulti = [];
        for body = 1:nBodies
            if rightHand(1,1,body) > 512
                rightHand(1,1,body) = 512;
            end
            
            if rightHand(1,2,body) > 424
                rightHand(1,2,body) = 424;
            end
            rightHandDepthM = depthMap(round(rightHand(1,2,body)),round(rightHand(1,1,body)));
            rightHandDepthMulti = [rightHandDepthMulti rightHandDepthM];
        end
        
        % Only track the lowest right hand depth value / closest hand
        [rightHandDepth,nearestHand] = min(rightHandDepthMulti);
        
        rightHandDepth;
        rightHandState = depthMetaData.HandRightState;
        rightHandState = rightHandState(trackedBodies(nearestHand));
        
        
        X1 = [round(rightHand(1,1,nearestHand)) round(rightThumb(1,1,nearestHand))];
        Y1 = [round(rightHand(1,2,nearestHand)) round(rightThumb(1,2,nearestHand))];
        line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', 'r');
        
        if rightHandDepth > 700
            rightHandBorder = [rightHand(:,:,nearestHand)-80 160 160];
            rectangle('position', rightHandBorder, 'EdgeColor', 'y', 'LineWidth', 3);
        elseif rightHandDepth < 600
            rightHandBorder = [rightHand(:,:,nearestHand)-80 160 160];
            rectangle('position', rightHandBorder, 'EdgeColor', 'r', 'LineWidth', 3);
        elseif rightHandDepth <700
            rightHandBorder = [rightHand(:,:,nearestHand)-80 160 160];
            rectangle('position', rightHandBorder, 'EdgeColor', 'g', 'LineWidth', 3);
            snapshotCounter = snapshotCounter + 1;
        end
        
        if snapshotCounter == 3
            i = i + 1;
            inputImage = imcrop(depthMap, [rightHand(:,:,nearestHand)-80 160 160]);
            Alphabet = ASL_recognition(rightHandState, inputImage)
            % Reset snapshotCounter
            snapshotCounter = 0;
            close;
        end
    
    end
end
stop(depthVid);
stop(colorVid);
close;