function varargout = GUI_WAM(varargin)
% GUI_WAM MATLAB code for GUI_WAM.fig
%      GUI_WAM, by itself, creates a new GUI_WAM or raises the existing
%      singleton*.
%
%      H = GUI_WAM returns the handle to a new GUI_WAM or the handle to
%      the existing singleton*.
%
%      GUI_WAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_WAM.M with the given input arguments.
%
%      GUI_WAM('Property','Value',...) creates a new GUI_WAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_WAM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_WAM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_WAM

% Last Modified by GUIDE v2.5 07-May-2019 15:09:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_WAM_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_WAM_OutputFcn, ...
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


% --- Executes just before GUI_WAM is made visible.
function GUI_WAM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_WAM (see VARARGIN)

set(handles.figure1, 'CurrentAxes', handles.axes_logo);
% wamImg = imread('images/wamarm.png');
wamImg = imread('images/Barrett-WAM.jpg');
% Display the original color image.
imshow(wamImg, []);

% Choose default command line output for GUI_WAM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_WAM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_WAM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rbtn_InvDyn.
function rbtn_InvDyn_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_InvDyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_InvDyn
selectController(hObject, eventdata, handles)


% --- Executes on button press in rbtn_RInvDyn.
function rbtn_RInvDyn_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_RInvDyn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_RInvDyn
selectController(hObject, eventdata, handles)

% --- Executes on button press in rbtn_AID.
function rbtn_AID_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_AID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_AID
selectController(hObject, eventdata, handles)

% --- Executes on button press in rbtn_PBRC.
function rbtn_PBRC_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_PBRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbtn_PBRC
selectController(hObject, eventdata, handles)

% --- Executes on button press in rbtn_PBAC.
function rbtn_PBAC_Callback(hObject, eventdata, handles)
% hObject    handle to rbtn_PBAC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selectController(hObject, eventdata, handles)

% Hint: get(hObject,'Value') returns toggle state of rbtn_PBAC

% --- Executes on button press in btn_run.
function btn_run_Callback(hObject, eventdata, handles)
% hObject    handle to btn_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    switch get(handles.uibuttongroup1.SelectedObject, 'String')
        case {'Inverse Dynamics'}
            disp('Simulate the system using Inverse Dynamics.');
        case {'Robust Inverse Dynamics'}
            disp('Simulate the system using Robust Inverse Dynamics.');
        case {'Adaptive Inverse Dynamics'}
            disp('Simulate the system using Adaptive Inverse Dynamics.');
        case {'Passivity-Based Robust Control'}
            disp('Simulate the system using Passivity-Based Robust Control.');
        case {'Passsivity-Based Adaptive Control'}
            disp('Simulate the system using Passsivity-Based Adaptive Control.');
    end
    
% FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function selectController(hObject, eventdata, handles)
    switch get(handles.uibuttongroup1.SelectedObject, 'String')
        case {'Inverse Dynamics'}
            disp('Selected Controller: Inverse Dynamics.');
        case {'Robust Inverse Dynamics'}
            disp('Selected Controller: Robust Inverse Dynamics.');
        case {'Adaptive Inverse Dynamics'}
            disp('Selected Controller: Adaptive Inverse Dynamics.');
        case {'Passivity-Based Robust Control'}
            disp('Selected Controller: Passivity-Based Robust Control.');
        case {'Passsivity-Based Adaptive Control'}
            disp('Selected Controller: Passsivity-Based Adaptive Control.');
    end
