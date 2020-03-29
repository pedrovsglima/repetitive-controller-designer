function varargout = config_plot_control(varargin)
% CONFIG_PLOT_CONTROL MATLAB code for config_plot_control.fig
%      CONFIG_PLOT_CONTROL, by itself, creates a new CONFIG_PLOT_CONTROL or raises the existing
%      singleton*.
%
%      H = CONFIG_PLOT_CONTROL returns the handle to a new CONFIG_PLOT_CONTROL or the handle to
%      the existing singleton*.
%
%      CONFIG_PLOT_CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIG_PLOT_CONTROL.M with the given input arguments.
%
%      CONFIG_PLOT_CONTROL('Property','Value',...) creates a new CONFIG_PLOT_CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before config_plot_control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to config_plot_control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help config_plot_control

% Last Modified by GUIDE v2.5 19-Nov-2019 11:18:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @config_plot_control_OpeningFcn, ...
                   'gui_OutputFcn',  @config_plot_control_OutputFcn, ...
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


% --- Executes just before config_plot_control is made visible.
function config_plot_control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to config_plot_control (see VARARGIN)

% Choose default command line output for config_plot_control
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes config_plot_control wait for user response (see UIRESUME)
% uiwait(handles.fig_config_plot_control);


% --- Outputs from this function are returned to the command line.
function varargout = config_plot_control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainfig = gcf;
% http://www.ece.northwestern.edu/local-apps/matlabhelp/techdoc/ref/findobj.html#:~:targetText=findobj%20locates%20graphics%20objects%20and,object%20and%20all%20its%20descendants.
% https://www.mathworks.com/matlabcentral/answers/408268-how-to-share-data-between-two-gui
GUI1        = findobj(allchild(groot), 'flat', 'Tag', 'fig_controlador');
handlesGUI1 = guidata(GUI1);
handlesGUI2 = guidata(hObject);

% validar valores escolhidos
x_min = str2num(get(handlesGUI2.edit_x_min, 'string'));
[x_minRows, x_minCols] = size(x_min);
if (isempty(x_min) || x_minRows ~= 1 || x_minCols ~= 1)
    errordlg('X Axis - "Min Limit" must be a number','Invalid Input','modal');
    return 
end

x_max = str2num(get(handlesGUI2.edit_x_max, 'string'));
[x_maxRows, x_maxCols] = size(x_max);
if (isempty(x_max) || x_maxRows ~= 1 || x_maxCols ~= 1)
    errordlg('X Axis - "Max Limit" must be a number','Invalid Input','modal');
    return 
end

if x_min >= x_max
    errordlg('X Axis - "Max Limit" must be greater than "Min Limit"','Invalid Input','modal');
    return
end     

y_min = str2num(get(handlesGUI2.edit_y_min, 'string'));
[y_minRows, y_minCols] = size(y_min);
if (isempty(y_min) || y_minRows ~= 1 || y_minCols ~= 1)
    errordlg('Y Axis - "Min Limit" must be a number','Invalid Input','modal');
    return 
end

y_max = str2num(get(handlesGUI2.edit_y_max, 'string'));
[y_maxRows, y_maxCols] = size(y_max);
if (isempty(y_max) || y_maxRows ~= 1 || y_maxCols ~= 1)
    errordlg('Y Axis - "Max Limit" must be a number','Invalid Input','modal');
    return 
end

if y_min >= y_max
    errordlg('Y Axis - "Max Limit" must be greater than "Min Limit"','Invalid Input','modal');
    return
end 

% atualizar limites do plot
set(handlesGUI1.plot_estabilidade, 'XLim', [x_min, x_max], 'YLim', [y_min, y_max]);

% plotar com novos limites
ControlData = getappdata(handlesGUI1.fig_controlador, 'ControlData');
q = ControlData.q_value;
a = ControlData.a_value;

if ~isempty(findobj('type','figure','tag','fig_controlador'))
    plotar(a, q, handlesGUI1, 0);
end

close(mainfig);
