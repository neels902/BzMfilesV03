function varargout = BzTool(varargin)
% BZTOOL MATLAB code for BzTool.fig
%      BZTOOL, by itself, creates a new BZTOOL or raises the existing
%      singleton*.
%
%      H = BZTOOL returns the handle to a new BZTOOL or the handle to
%      the existing singleton*.
%
%      BZTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BZTOOL.M with the given input arguments.
%
%      BZTOOL('Property','Value',...) creates a new BZTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BzTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BzTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BzTool

% Last Modified by GUIDE v2.5 19-Aug-2015 16:06:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BzTool_OpeningFcn, ...
                   'gui_OutputFcn',  @BzTool_OutputFcn, ...
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


% --- Executes just before BzTool is made visible.
function BzTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BzTool (see VARARGIN)

% initiate the input variables;
Hinput.so = [-5.03,13.13];
Hinput.I_tilt = 38.01;
Hinput.I_haf = 45.28;
Hinput.I_Mgram ='North';
Hinput.cycle = 23;

%Hinput.ftsStr = '../AIAfts/event03_20120310_023749_AIA_171_.fts';
Hinput.ftsStr = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/iSWACygnetStreamer?timestamp=2040-01-01%2002:24:47.0&window=-1&cygnetId=237';
Hinput.enlilBB = 15; % '../Insitu/enlil/ev03.txt';
Hinput.enlilVV = 650;
Hinput.insitu = 'http://iswa.ccmc.gsfc.nasa.gov/IswaSystemWebApp/DatabaseDataStreamServlet?format=JSON&resource=ACE,ACE,ACE&quantity=B_x,B_y,B_z&';
%'http://iswa.ccmc.gsfc.nasa.gov/IswaSystemWebApp/DatabaseDataStreamServlet?format=TEXT&resource=ACE,ACE,ACE&quantity=B_x,B_y,B_z&begin-time=2015-08-18%2015:59:59&end-time=2015-08-19%2023:59:59';
Hinput.AT=datenum([2012,03,12,012,20,00]);
Hinput.ccmc = [5.0,9.0];
Hinput.swpc = [1.0,9.0];


handles.Hinput= Hinput;
% Choose default command line output for BzTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BzTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BzTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in popupmenuSphere.
function popupmenuSphere_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuSphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');

% Set current data to the selected data set.
switch str{val};
case 'North' % Odd Solar cycle.
   handles.Hinput.I_Mgram = 'North';
case 'South' % Even Solar cycle.
   handles.Hinput.I_Mgram = 'South';
end
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenuSphere_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuSphere (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuCycle.
function popupmenuCycle_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine the selected data set.
str = get(hObject, 'String');
val = get(hObject,'Value');

Stsc20=[1964,10,15,0,0,0];
Stsc21=[1976,5,15,0,0,0];
Stsc22=[1986,3,15,0,0,0];
Stsc23=[1996,6,15,0,0,0];
Stsc24=[2008,1,15,0,0,0];

% Set current data to the selected data set.
switch str{val};
case '+ve' % Odd Solar cycle.
   handles.Hinput.cycle = 24;
case '-ve' % Even Solar cycle.
   handles.Hinput.cycle = 23;
end
% Save the handles structure.
guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuCycle contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuCycle


% --- Executes during object creation, after setting all properties.
function popupmenuCycle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuCycle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%


function editLat_Callback(hObject, eventdata, handles)
% hObject    handle to editLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ssoLat = str2double(get(hObject,'String'));
handles.Hinput.so(1,1)=ssoLat;
% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editLat as text
%        str2double(get(hObject,'String')) returns contents of editLat as a double


% --- Executes during object creation, after setting all properties.
function editLat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editlon_Callback(hObject, eventdata, handles)
% hObject    handle to editlon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ssoLon = str2double(get(hObject,'String'));
handles.Hinput.so(1,2)=ssoLon;
% Save the handles structure.
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function editlon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editlon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editTilt_Callback(hObject, eventdata, handles)
% hObject    handle to editTilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xaxisTilt = str2double(get(hObject,'String'));
handles.Hinput.I_tilt=xaxisTilt;
% Save the handles structure.
guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of editTilt as text
%        str2double(get(hObject,'String')) returns contents of editTilt as a double


% --- Executes during object creation, after setting all properties.
function editTilt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editHaf_Callback(hObject, eventdata, handles)
% hObject    handle to editHaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

HAF=str2double(get(hObject,'String'));
handles.Hinput.I_haf=HAF;
% Save the handles structure.
guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of editHaf as text
%        str2double(get(hObject,'String')) returns contents of editHaf as a double


% --- Executes during object creation, after setting all properties.
function editHaf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHaf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%


function editFts_Callback(hObject, eventdata, handles)
% hObject    handle to editFts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles.Hinput.ftsStr=get(hObject,'String');
handles.Hinput.ftsStr = 'http://iswa.gsfc.nasa.gov/IswaSystemWebApp/iSWACygnetStreamer?timestamp=2040-01-01%2002:24:47.0&window=-1&cygnetId=237';

% '../AIAfts/event03_20120310_023749_AIA_171_.fts'
% Save the handles structure.
guidata(hObject,handles)

% Hints: get(hObject,'String') returns contents of editFts as text
%        str2double(get(hObject,'String')) returns contents of editFts as a double


% --- Executes during object creation, after setting all properties.
function editFts_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editBB_Callback(hObject, eventdata, handles)
% hObject    handle to editBB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

BBtemp=str2double(get(hObject,'String'));
handles.Hinput.enlilBB=BBtemp;
%handles.Hinput.enlil=get(hObject,'String');
% '../Insitu/enlil/ev03.txt'
% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editBB as text
%        str2double(get(hObject,'String')) returns contents of editBB as a double


% --- Executes during object creation, after setting all properties.
function editBB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editVV_Callback(hObject, eventdata, handles)
% hObject    handle to editVV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

VVtemp=str2double(get(hObject,'String'));
handles.Hinput.enlilVV=VVtemp;
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editVV as text
%        str2double(get(hObject,'String')) returns contents of editVV as a double


% --- Executes during object creation, after setting all properties.
function editVV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editVV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editInsitu_Callback(hObject, eventdata, handles)
% hObject    handle to editInsitu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Hinput.insitu=get(hObject,'String');
% '../Insitu/Omni/E03_Omni.txt'
% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editInsitu as text
%        str2double(get(hObject,'String')) returns contents of editInsitu as a double


% --- Executes during object creation, after setting all properties.
function editInsitu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editInsitu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%


function editAT_Callback(hObject, eventdata, handles)
% hObject    handle to editAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

DateString = get(hObject,'String');
formatIn = 'yyyy,mmm,dd,HH,MM,SS';
handles.Hinput.AT=datenum(DateString,formatIn);

% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editAT as text
%        str2double(get(hObject,'String')) returns contents of editAT as a double


% --- Executes during object creation, after setting all properties.
function editAT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editAT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCCMCmin_Callback(hObject, eventdata, handles)
% hObject    handle to editCCMCmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ccmcMin = str2double(get(hObject,'String'));
handles.Hinput.ccmc(1,1)=ccmcMin;
% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editCCMCmin as text
%        str2double(get(hObject,'String')) returns contents of editCCMCmin as a double


% --- Executes during object creation, after setting all properties.
function editCCMCmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCCMCmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editCCMCmax_Callback(hObject, eventdata, handles)
% hObject    handle to editCCMCmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ccmcMax = str2double(get(hObject,'String'));
handles.Hinput.ccmc(1,2)=ccmcMax;
% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editCCMCmax as text
%        str2double(get(hObject,'String')) returns contents of editCCMCmax as a double


% --- Executes during object creation, after setting all properties.
function editCCMCmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCCMCmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSWPCmin_Callback(hObject, eventdata, handles)
% hObject    handle to editSWPCmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

swpcMin = str2double(get(hObject,'String'));
handles.Hinput.swpc(1,1)=swpcMin;
% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editSWPCmin as text
%        str2double(get(hObject,'String')) returns contents of editSWPCmin as a double


% --- Executes during object creation, after setting all properties.
function editSWPCmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSWPCmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSWPCmax_Callback(hObject, eventdata, handles)
% hObject    handle to editSWPCmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

swpcMax = str2double(get(hObject,'String'));
handles.Hinput.swpc(1,2)=swpcMax;
% Save the handles structure.
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of editSWPCmax as text
%        str2double(get(hObject,'String')) returns contents of editSWPCmax as a double


% --- Executes during object creation, after setting all properties.
function editSWPCmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSWPCmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in BzPredict.
function BzPredict_Callback(hObject, eventdata, handles)
% hObject    handle to BzPredict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tool_Inputs=handles.Hinput  % - used for printing out  
%temp2 = TOPTREEBz('NoLongerUsed');  % 'ev03'
temp2 = TOPTREEBzTool(handles);  % 'ev03'


% --- Executes during object creation, after setting all properties.
function BzPredict_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BzPredict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
