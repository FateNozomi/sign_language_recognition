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

% Last Modified by GUIDE v2.5 07-Sep-2016 23:02:59

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


% --- Executes on button press in start_kinect_pushbutton.
function start_kinect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to start_kinect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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



% --- Executes on button press in stop_kinect_pushbutton.
function stop_kinect_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to stop_kinect_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in exit_pushbutton.
function exit_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to exit_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close kinect_gui.
function kinect_gui_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to kinect_gui (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
