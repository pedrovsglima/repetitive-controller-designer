function varargout = config_slider(varargin)
% CONFIG_SLIDER MATLAB code for config_slider.fig
%      CONFIG_SLIDER, by itself, creates a new CONFIG_SLIDER or raises the existing
%      singleton*.
%
%      H = CONFIG_SLIDER returns the handle to a new CONFIG_SLIDER or the handle to
%      the existing singleton*.
%
%      CONFIG_SLIDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONFIG_SLIDER.M with the given input arguments.
%
%      CONFIG_SLIDER('Property','Value',...) creates a new CONFIG_SLIDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before config_slider_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to config_slider_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help config_slider

% Last Modified by GUIDE v2.5 14-Nov-2019 11:55:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @config_slider_OpeningFcn, ...
                   'gui_OutputFcn',  @config_slider_OutputFcn, ...
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


% --- Executes just before config_slider is made visible.
function config_slider_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to config_slider (see VARARGIN)

% Choose default command line output for config_slider
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes config_slider wait for user response (see UIRESUME)
% uiwait(handles.fig_config_slider);


% --- Outputs from this function are returned to the command line.
function varargout = config_slider_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_ok.
function button_ok_Callback(hObject, eventdata, handles)
% hObject    handle to button_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainfig = gcf;
% http://www.ece.northwestern.edu/local-apps/matlabhelp/techdoc/ref/findobj.html#:~:targetText=findobj%20locates%20graphics%20objects%20and,object%20and%20all%20its%20descendants.
% https://www.mathworks.com/matlabcentral/answers/408268-how-to-share-data-between-two-gui
GUI1        = findobj(allchild(groot), 'flat', 'Tag', 'fig_controlador');
handlesGUI1 = guidata(GUI1);
handlesGUI2 = guidata(hObject);

% validar valores escolhidos
a_min = str2num(get(handlesGUI2.edit_a_min, 'string'));
[a_minRows, a_minCols] = size(a_min);
if (isempty(a_min) || a_minRows ~= 1 || a_minCols ~= 1)
    errordlg('a Parameter - "Min Limit" must be a number','Invalid Input','modal');
    return 
end

a_max = str2num(get(handlesGUI2.edit_a_max, 'string'));
[a_maxRows, a_maxCols] = size(a_max);
if (isempty(a_max) || a_maxRows ~= 1 || a_maxCols ~= 1)
    errordlg('a Parameter - "Max Limit" must be a number','Invalid Input','modal');
    return 
end

a_step = str2num(get(handlesGUI2.edit_a_step, 'string'));
[a_stepRows, a_stepCols] = size(a_step);
if (isempty(a_step) || a_stepRows ~= 1 || a_stepCols ~= 1)
    errordlg('a Parameter - "Step" must be a number','Invalid Input','modal');
    return 
end

if a_min >= a_max
    errordlg('a Parameter - "Max Limit" must be greater than "Min Limit"','Invalid Input','modal');
    return
end  
a = (a_max+a_min)/2;
if (a_step > a_max-a)
    errordlg('a Parameter - "Step" value is too high','Invalid Input','modal');
    return 
end    

a_precisao = str2num(get(handlesGUI2.edit_a_precision, 'string'));
[a_precisaoRows, a_precisaoCols] = size(a_precisao);
if (isempty(a_precisao) || a_precisaoRows ~= 1 || a_precisaoCols ~= 1)
    errordlg('a Parameter - "Digits of Precision" must be a number','Invalid Input','modal');
    return 
end

if (a_precisao < 0)
    errordlg('a Parameter - "Digits of Precision" must be greater than or equal 0','Invalid Input','modal');
    return 
end    

q_min = str2num(get(handlesGUI2.edit_q_min, 'string'));
[q_minRows, q_minCols] = size(q_min);
if (isempty(q_min) || q_minRows ~= 1 || q_minCols ~= 1)
    errordlg('Q Parameter - "Min Limit" must be a number','Invalid Input','modal');
    return 
end

q_max = str2num(get(handlesGUI2.edit_q_max, 'string'));
[q_maxRows, q_maxCols] = size(q_max);
if (isempty(q_max) || q_maxRows ~= 1 || q_maxCols ~= 1)
    errordlg('Q Parameter - "Max Limit" must be a number','Invalid Input','modal');
    return 
end  

q_step = str2num(get(handlesGUI2.edit_q_step, 'string'));
[q_stepRows, q_stepCols] = size(q_step);
if (isempty(q_step) || q_stepRows ~= 1 || q_stepCols ~= 1)
    errordlg('Q Parameter - "Step" must be a number','Invalid Input','modal');
    return 
end

if q_min >= q_max
    errordlg('Q Parameter - "Max Limit" must be greater than "Min Limit"','Invalid Input','modal');
    return
end
q = (q_max+q_min)/2;
if (q_step > q_max-q)
    errordlg('Q Parameter - "Step" value is too high','Invalid Input','modal');
    return 
end 

q_precisao = str2num(get(handlesGUI2.edit_q_precision, 'string'));
[q_precisaoRows, q_precisaoCols] = size(q_precisao);
if (isempty(q_precisao) || q_precisaoRows ~= 1 || q_precisaoCols ~= 1)
    errordlg('Q Parameter - "Digits of Precision" must be a number','Invalid Input','modal');
    return 
end

if (q_precisao < 0)
    errordlg('Q Parameter - "Digits of Precision" must be greater than or equal 0','Invalid Input','modal');
    return 
end  

% atualizar slider parâmetro a
set(handlesGUI1.slider_a_value, 'Min', a_min, 'Max', a_max);
set(handlesGUI1.slider_a_value, 'value', a);
set(handlesGUI1.edit_a_value, 'value', a);
set(handlesGUI1.text_slider_min, 'String', num2str(a_min));
set(handlesGUI1.text_slider_max, 'String', num2str(a_max));
slider_a_step = ones(1, 2);
slider_a_step(1) = a_step/(a_max - a_min);
slider_a_step(2) = a_step/(a_max - a_min);
set(handlesGUI1.slider_a_value, 'SliderStep' , slider_a_step);

% atualizar slider parâmetro Q
set(handlesGUI1.slider_q_value, 'Min', q_min, 'Max', q_max);
set(handlesGUI1.slider_q_value, 'value', q);
set(handlesGUI1.edit_q_value, 'value', q);
set(handlesGUI1.text_slider_qmin, 'String', num2str(q_min));
set(handlesGUI1.text_slider_qmax, 'String', num2str(q_max));
slider_q_step = ones(1, 2);
slider_q_step(1) = q_step/(q_max - q_min);
slider_q_step(2) = q_step/(q_max - q_min);
set(handlesGUI1.slider_q_value, 'SliderStep' , slider_q_step);

% atualizar valores de 'a' e 'q' que são salvos na estrutura
ControlData = getappdata(handlesGUI1.fig_controlador, 'ControlData');
if (get(handlesGUI1.checkbox_a_value, 'value') == 1)
   a = ControlData.a_value;
else
   ControlData.a_value = a; 
end
if (get(handlesGUI1.checkbox_q_value, 'value') == 1)
   q = ControlData.q_value;
else
   ControlData.q_value = q; 
end
ControlData.a_precision = a_precisao;
ControlData.q_precision = q_precisao;
setappdata(handlesGUI1.fig_controlador, 'ControlData', ControlData);

if ~isempty(findobj('type','figure','tag','fig_controlador'))
    plotar(a, q, handlesGUI1, 0);
end

close(mainfig);
