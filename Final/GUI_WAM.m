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

% Last Modified by GUIDE v2.5 10-May-2019 19:49:28

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

[M, C, G, F, TH, Y] = getWAMParameters();
[Mfcn, Cfcn, Gfcn, Ffcn, Yfcn, Yavfcn, TH] = convertSymVarsTOfunctions(M, C, G, F, TH);
handles.Mfcn    = Mfcn;
handles.Cfcn    = Cfcn;
handles.Gfcn    = Gfcn;
handles.Ffcn    = Ffcn;
handles.Yfcn    = Yfcn;
handles.Yavfcn  = Yavfcn;
handles.TH      = TH;
handles.M    = M;
handles.C    = C;
handles.G    = G;
handles.F    = F;
handles.Y    = Y;
handles.TH   = TH;

handles.Q0 = [pi/4, pi/4, pi/4, pi/4, pi/4, pi/4];
% handles.Q0 = [0, -.5, 0, 1, 1, .75];
handles.w = 1;     % Frequency
handles.LevelPer = 0;

handles.paramNameValStruct.StopTime = '10';
handles.paramNameValStruct.SrcWorkspace = 'current';

handles.pax(1) = subplot(331,'Parent', handles.panel_plot); hold on; box on;
handles.pax(2) = subplot(332,'Parent', handles.panel_plot); hold on; box on;
handles.pax(3) = subplot(333,'Parent', handles.panel_plot); hold on; box on;
handles.pax(4) = subplot(334,'Parent', handles.panel_plot); hold on; box on;
handles.pax(5) = subplot(335,'Parent', handles.panel_plot); hold on; box on;
handles.pax(6) = subplot(336,'Parent', handles.panel_plot); hold on; box on;
handles.pax(7) = subplot(337,'Parent', handles.panel_plot); hold on; box on;
handles.pax(8) = subplot(338,'Parent', handles.panel_plot); hold on; box on;
handles.pax(9) = subplot(339,'Parent', handles.panel_plot); hold on; box on;

handles.select = 1;

t = 0:1e-3:str2num(handles.paramNameValStruct.StopTime);
Q1 = sin(t);        Q1d = cos(t);       Q1dd = -sin(t);
Q2 = -.5+sin(t);    Q2d = cos(t);      Q2dd = sin(t);
Q4 = .75*sin(t);    Q4d = .75*cos(t);   Q4dd = -.75*sin(t);

handles.Q = [Q1; Q2; Q4; Q1d; Q2d; Q4d; Q1dd; Q2dd; Q4dd];


handles.hd(1) = plot(handles.pax(1), t, Q1, 'LineWidth', 1.5);  ylabel(handles.pax(1), 'q1');
handles.hd(2) = plot(handles.pax(4), t, Q1d, 'LineWidth', 1.5);  ylabel(handles.pax(4), 'q1dot');

handles.hd(3) = plot(handles.pax(2), t, Q2, 'LineWidth', 1.5); ylabel(handles.pax(2), 'q2');
handles.hd(4) = plot(handles.pax(5), t, Q2d, 'LineWidth', 1.5); ylabel(handles.pax(5), 'q2dot');

handles.hd(5) = plot(handles.pax(3), t, Q4, 'LineWidth', 1.5); ylabel(handles.pax(3), 'q4');
handles.hd(6) = plot(handles.pax(6), t, Q4d, 'LineWidth', 1.5); ylabel(handles.pax(6), 'q4dot');
set(handles.hd,'Visible','off');

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

col = get(handles.btn_run,'backg'); 
set(handles.btn_run,'str','RUNNING...','backg',[.1 .6 .1]);
drawnow;


% set(handles.btn_run,'str','RUN Simulation','backg',col) 

Mfcn    = handles.Mfcn;
Cfcn    = handles.Cfcn;
Gfcn    = handles.Gfcn;
Ffcn    = handles.Ffcn;
Yfcn    = handles.Yfcn;
Yavfcn  = handles.Yavfcn;
TH      = handles.TH;
% Q0      = handles.Q0;
w       = handles.w;

rho = str2num(get(handles.rho, 'String'));

switch get(handles.uibuttongroup1.SelectedObject, 'String')
    case {'Inverse Dynamics'}
        disp('Simulate the system using Inverse Dynamics.');

        simOut = sim('sim_WAM_InverseDynamics', handles.paramNameValStruct); 
        plotStates(simOut.t, simOut.Q, handles.pax, simOut.Tau);

    case {'Robust Inverse Dynamics'}
         msgbox('Implementation in progressing', 'Icon','warn');
        
    case {'Adaptive Inverse Dynamics'}
        msgbox('Implementation in progressing', 'Icon','warn');

    case {'Passivity-Based Motion Control'}
        disp('Passivity-Based Motion Control');
        
        simOut = sim('sim_WAM_PBMCDynamics', handles.paramNameValStruct); 
        plotStates(simOut.t, simOut.Q, handles.pax, simOut.Tau);

    case {'Passivity-Based Robust Control'}
        disp('Simulate the system using Passivity-Based Robust Control.');
        
        if handles.LevelPer ~= 0
            lvl = 2*handles.LevelPer*rand(27,1) - handles.LevelPer + 1;
            [Mfcn, Cfcn, Gfcn, Ffcn, Yfcn, Yavfcn, TH] = ...
                convertSymVarsTOfunctions(handles.M, handles.C, handles.G, handles.F, handles.TH.*lvl);
        end

        sim_flag = false;
        if isempty(str2num(get(handles.rho, 'String')))
            answer = questdlg('Auto set gains ?','Boundary Condition', 'Yes', 'No', 'No idea');
            switch answer
                case 'Yes'
                    set(handles.gamma, 'String', '5');
                    set(handles.rho, 'String', '3');
                    set(handles.eps, 'String', '.1');
                    set(handles.k1, 'String', '2');
                    set(handles.k2, 'String', '2');
                    set(handles.k3, 'String', '2');
                    set(handles.lbd1, 'String', '3');
                    set(handles.lbd2, 'String', '3');
                    set(handles.lbd3, 'String', '3');
                    sim_flag = true;
            end
        else
            sim_flag = true;
        end
        
        if sim_flag 
            rho = str2num(get(handles.rho, 'String'));
            eps = str2num(get(handles.eps, 'String'));
            k1 = str2num(get(handles.k1, 'String'));
            k2 = str2num(get(handles.k2, 'String'));
            k3 = str2num(get(handles.k3, 'String'));
            lbd1 = str2num(get(handles.lbd1, 'String'));
            lbd2 = str2num(get(handles.lbd2, 'String'));
            lbd3 = str2num(get(handles.lbd3, 'String'));

            K = diag([k1 k2 k3]);
            Lambda = diag([lbd1 lbd2 lbd3]);

            TH0 = TH;

            simOut = sim('sim_WAM_PBRCDynamics', handles.paramNameValStruct); 
            plotStates(simOut.t, simOut.Q, handles.pax, simOut.Tau);
        end
        
    case {'Passsivity-Based Adaptive Control'}
        disp('Simulate the system using Passsivity-Based Adaptive Control.');
        
        k1 = str2num(get(handles.k1, 'String'));
        k2 = str2num(get(handles.k2, 'String'));
        k3 = str2num(get(handles.k3, 'String'));
        lbd1 = str2num(get(handles.lbd1, 'String'));
        lbd2 = str2num(get(handles.lbd2, 'String'));
        lbd3 = str2num(get(handles.lbd3, 'String'));
        Gamma = str2num(get(handles.gamma, 'String'));
        
        K = diag([k1 k2 k3]);
        Lambda = diag([lbd1 lbd2 lbd3]);
        
        if handles.LevelPer ~= 0
            lvl = 2*handles.LevelPer*rand(27,1) - handles.LevelPer + 1;
        else
            lvl = ones(27,1);
        end
        
        simOut = sim('sim_WAM_PBACDynamics', handles.paramNameValStruct);
        plotStates(simOut.t, simOut.Q, handles.pax, simOut.Tau);
end
set(handles.btn_run,'str','RUN Simulation','backg',col) 
guidata(hObject, handles);


function lbd1_Callback(hObject, eventdata, handles)
% hObject    handle to lbd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lbd1 as text
%        str2double(get(hObject,'String')) returns contents of lbd1 as a double


% --- Executes during object creation, after setting all properties.
function lbd1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lbd2_Callback(hObject, eventdata, handles)
% hObject    handle to lbd2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lbd2 as text
%        str2double(get(hObject,'String')) returns contents of lbd2 as a double


% --- Executes during object creation, after setting all properties.
function lbd2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbd2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lbd3_Callback(hObject, eventdata, handles)
% hObject    handle to lbd3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lbd3 as text
%        str2double(get(hObject,'String')) returns contents of lbd3 as a double


% --- Executes during object creation, after setting all properties.
function lbd3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbd3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k1_Callback(hObject, eventdata, handles)
% hObject    handle to k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k1 as text
%        str2double(get(hObject,'String')) returns contents of k1 as a double


% --- Executes during object creation, after setting all properties.
function k1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k2_Callback(hObject, eventdata, handles)
% hObject    handle to k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k2 as text
%        str2double(get(hObject,'String')) returns contents of k2 as a double


% --- Executes during object creation, after setting all properties.
function k2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k3_Callback(hObject, eventdata, handles)
% hObject    handle to k3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k3 as text
%        str2double(get(hObject,'String')) returns contents of k3 as a double


% --- Executes during object creation, after setting all properties.
function k3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rho_Callback(hObject, eventdata, handles)
% hObject    handle to rho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rho as text
%        str2double(get(hObject,'String')) returns contents of rho as a double


% --- Executes during object creation, after setting all properties.
function rho_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rho (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eps_Callback(hObject, eventdata, handles)
% hObject    handle to eps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps as text
%        str2double(get(hObject,'String')) returns contents of eps as a double


% --- Executes during object creation, after setting all properties.
function eps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
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
        case {'Passivity-Based Motion Control'}
            disp('Passivity-Based Motion Control');
        case {'Passivity-Based Robust Control'}
            disp('Selected Controller: Passivity-Based Robust Control.');
        case {'Passsivity-Based Adaptive Control'}
            disp('Selected Controller: Passsivity-Based Adaptive Control.');
    end



function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma as text
%        str2double(get(hObject,'String')) returns contents of gamma as a double


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i=1:length(handles.pax)
    cla(handles.pax(i));
end

t = 0:1e-3:str2num(handles.paramNameValStruct.StopTime);
Q1 = sin(t);        Q1d = cos(t);       Q1dd = -sin(t);
Q2 = -.5+sin(t);    Q2d = cos(t);      Q2dd = sin(t);
Q4 = .75*sin(t);    Q4d = .75*cos(t);   Q4dd = -.75*sin(t);

handles.hd(1) = plot(handles.pax(1), t, Q1, 'LineWidth', 1.5);  ylabel(handles.pax(1), 'q1');
handles.hd(2) = plot(handles.pax(4), t, Q1d, 'LineWidth', 1.5);  ylabel(handles.pax(4), 'q1dot');

handles.hd(3) = plot(handles.pax(2), t, Q2, 'LineWidth', 1.5); ylabel(handles.pax(2), 'q2');
handles.hd(4) = plot(handles.pax(5), t, Q2d, 'LineWidth', 1.5); ylabel(handles.pax(5), 'q2dot');

handles.hd(5) = plot(handles.pax(3), t, Q4, 'LineWidth', 1.5); ylabel(handles.pax(3), 'q4');
handles.hd(6) = plot(handles.pax(6), t, Q4d, 'LineWidth', 1.5); ylabel(handles.pax(6), 'q4dot');
set(handles.hd,'Visible','off');

% t = 0:.1:str2num(handles.paramNameValStruct.StopTime);
% handles.ho(1) = plot(handles.pax(1), t, handles.Q(:,1), 'LineWidth', 1.5);  ylabel(handles.pax(1), 'q1');
% handles.ho(2) = plot(handles.pax(4), t, handles.Q(:,4), 'LineWidth', 1.5);  ylabel(handles.pax(4), 'q1dot');
% 
% handles.ho(3) = plot(handles.pax(2), t, handles.Q(:,2), 'LineWidth', 1.5); ylabel(handles.pax(2), 'q2');
% handles.ho(4) = plot(handles.pax(5), t, handles.Q(:,5), 'LineWidth', 1.5); ylabel(handles.pax(5), 'q2dot');
% 
% handles.ho(5) = plot(handles.pax(3), t, handles.Q(:,3), 'LineWidth', 1.5); ylabel(handles.pax(3), 'q4');
% handles.ho(6) = plot(handles.pax(6), t, handles.Q(:,6), 'LineWidth', 1.5); ylabel(handles.pax(6), 'q4dot');
% set(handles.ho,'Visible','off');

set(handles.checkbox1,'value',0);
set(handles.checkbox2,'value',0);
set(handles.checkbox3,'value',0);
set(handles.checkbox4,'value',0);

guidata(hObject, handles);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.gamma, 'String', '5');
set(handles.rho, 'String', '5');
set(handles.eps, 'String', '.1');
set(handles.k1, 'String', '10');
set(handles.k2, 'String', '30');
set(handles.k3, 'String', '5');
set(handles.lbd1, 'String', '5');
set(handles.lbd2, 'String', '10');
set(handles.lbd3, 'String', '5');

        


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

if get(hObject,'Value')
    set(handles.hd,'Visible','on')
else
    set(handles.hd,'Visible','off')
end


% --- Executes on slider movement.
function level_Callback(hObject, eventdata, handles)
% hObject    handle to level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.LevelPer = get(hObject, 'Value');
set(handles.txt_level, 'String', num2str(handles.LevelPer,3));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function level_CreateFcn(hObject, eventdata, handles)
% hObject    handle to level (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btnOpt.
function btnOpt_Callback(hObject, eventdata, handles)
% hObject    handle to btnOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


col = get(handles.btnOpt,'backg'); 
set(handles.btnOpt,'str','RUNNING OPTIMIZATION ...','backg',[.1 .6 .1]);
drawnow;

GetOptimalTrajectories
% t = 0:.1:10;
% Q1 = sin(t);        Q1d = cos(t);       Q1dd = -sin(t);
% Q2 = -.5+sin(t);    Q2d = cos(t);      Q2dd = sin(t);
% Q4 = .75*sin(t);    Q4d = .75*cos(t);   Q4dd = -.75*sin(t);
% 
% q = [Q1; Q2; Q4];
% qd = [Q1d; Q2d; Q4d];
% qdd = [Q1dd; Q2dd; Q4dd];
% handles.Tau = q;
% handles.Q = [q; qd; qdd].';
handles.Q = [q qd qdd];
handles.Tau = Tau;

handles.ho(1) = plot(handles.pax(1), t, handles.Q(:,1), 'LineWidth', 1.5);  ylabel(handles.pax(1), 'q1');
handles.ho(2) = plot(handles.pax(4), t, handles.Q(:,4), 'LineWidth', 1.5);  ylabel(handles.pax(4), 'q1dot');

handles.ho(3) = plot(handles.pax(2), t, handles.Q(:,2), 'LineWidth', 1.5); ylabel(handles.pax(2), 'q2');
handles.ho(4) = plot(handles.pax(5), t, handles.Q(:,5), 'LineWidth', 1.5); ylabel(handles.pax(5), 'q2dot');

handles.ho(5) = plot(handles.pax(3), t, handles.Q(:,3), 'LineWidth', 1.5); ylabel(handles.pax(3), 'q4');
handles.ho(6) = plot(handles.pax(6), t, handles.Q(:,6), 'LineWidth', 1.5); ylabel(handles.pax(6), 'q4dot');

% plotStates(t, handles.Q, handles.pax, handles.Tau.')
set(handles.btnOpt,'str','FIND Optimal Trajectories','backg',col) 
set(handles.checkbox3,'value',1);

set(handles.gamma, 'String', '5');
set(handles.rho, 'String', '5');
set(handles.eps, 'String', '.1');
set(handles.k1, 'String', '10');
set(handles.k2, 'String', '30');
set(handles.k3, 'String', '5');
set(handles.lbd1, 'String', '5');
set(handles.lbd2, 'String', '10');
set(handles.lbd3, 'String', '5');
                    
guidata(hObject, handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

if get(hObject,'Value')
%     handles.select = 0;
%     handles.Q0 = handles.Q(1,:);
    handles.Q0 = [0, -.5, 0, 0, 0, 0];
    set(handles.checkbox3,'value',0);
    set(handles.checkbox4,'value',0);
    guidata(hObject, handles);
end

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3

% OPtimal

if get(hObject,'Value')
    handles.select = 0;
    handles.Q0 = handles.Q(1,1:6);
    set(handles.checkbox2,'value',0);
    set(handles.checkbox4,'value',0);
    set(handles.ho,'Visible','on');
    guidata(hObject, handles);
else
    set(handles.ho,'Visible','off');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4

% Different IC
if get(hObject,'Value')
%     handles.select = 0;
%     handles.Q0 = handles.Q(1,:);
    handles.Q0 = [pi/4, pi/4, pi/4, pi/4, pi/4, pi/4];
    set(handles.checkbox2,'value',0);
    set(handles.checkbox3,'value',0);
    guidata(hObject, handles);
end
