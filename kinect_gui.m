function varargout = kinect_gui(varargin)
% KINECT_GUI MATLAB code for kinect_gui.fig
%      KINECT_GUI, by itself, creates a new KINECT_GUI or raises the existing
%      singleton*.
%
%      H = KINECT_GUI returns the handle to a new KINECT_GUI or the handle to
%      the existing singleton*.
%
%      KINECT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KINECT_GUI.M with the given input arguments.
%
%      KINECT_GUI('Property','Value',...) creates a new KINECT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before kinect_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to kinect_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help kinect_gui

% Last Modified by GUIDE v2.5 09-Sep-2016 00:18:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @kinect_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @kinect_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before kinect_gui is made visible.
function kinect_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to kinect_gui (see VARARGIN)

axes(handles.kinect_axes);
% initialize kinect RGB input
colorVid = videoinput('kinect',1,'RGB_640x480');

% Create an image object for previewing.
% http://www.mathworks.com/help/imaq/preview.html
% Use get(colorVid) to view a complete list of all the properties 
% supported by a video input object or a video source object
% VideoResolution of colorVid returns an array of [640 480]
% vidRes(2) returns the height of colorVid
% vidRes(1) returns the width of colorVid
% nBands    returns number of color bands in data to be acquired
vidRes = colorVid.VideoResolution;
nBands = colorVid.NumberOfBands;
% create placeholder image which matches source
hImage = image( zeros(vidRes(2), vidRes(1), nBands) );
preview(colorVid, hImage);

axes(handles.sign_axes);
asl_preview_directory = [pwd '\asl_preview'];
% Select files using a specified pattern
filePattern = fullfile(asl_preview_directory, '*.png');
% Lists out all required files which follows the pattern
reqFiles = dir(filePattern);
for k = 1 : length(reqFiles)
    %Index into the structure to access a particular item from reqFiles
    baseFileName = reqFiles(k).name;
    %fullfile returns a string containing the full path to the file
    baseFilePath = fullfile(asl_preview_directory, baseFileName);
    fprintf(1, 'Accessing %s\n', baseFilePath);
    %Create cell array S of size() [2,K]
    %Fills up first row of S with length(reqFiles)
    handles.S{1,k} = k;
    %Fills up second row of S imread(baseFilePath)
    handles.S{2,k} = imread(baseFilePath);
end
% converts cell to matrix in order to imshow
handles.signA = imshow(cell2mat(handles.S(2,1)));
handles.current_sign = handles.signA;

% Choose default command line output for kinect_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes kinect_gui wait for user response (see UIRESUME)
% uiwait(handles.kinect_gui);


% --- Outputs from this function are returned to the command line.
function varargout = kinect_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in alphabet_popupmenu.
function alphabet_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to alphabet_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns alphabet_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from alphabet_popupmenu

val = get(hObject, 'Value');
str = get(hObject, 'String');
switch str{val}
    case 'A'
        handles.signA = imshow(cell2mat(handles.S(2,1)));
        handles.current_sign = handles.signA;
    case 'B'
        handles.signB = imshow(cell2mat(handles.S(2,2)));
        handles.current_sign = handles.signB;
    case 'C'
        handles.signC = imshow(cell2mat(handles.S(2,3)));
        handles.current_sign = handles.signC;
end
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function alphabet_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphabet_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_sign_pushbutton.
function check_sign_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to check_sign_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
S = PCA_v2_Kinect_Input_fcn;
switch handles.current_sign
    case handles.signA
        if S == 'A'
             set(handles.output_text, 'String', 'Correct');
        else
            set(handles.output_text, 'String', 'Wrong');
        end
    case handles.signB
        if S == 'B'
             set(handles.output_text, 'String', 'Correct');
        else
            set(handles.output_text, 'String', 'Wrong');
        end
    case handles.signC
        if S == 'C'
             set(handles.output_text, 'String', 'Correct');
        else
            set(handles.output_text, 'String', 'Wrong');
        end
end



% --- Executes when user attempts to close kinect_gui.
function kinect_gui_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to kinect_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
