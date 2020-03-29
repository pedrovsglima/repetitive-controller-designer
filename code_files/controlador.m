function varargout = controlador(varargin)
% CONTROLADOR MATLAB code for controlador.fig
%      CONTROLADOR, by itself, creates a new CONTROLADOR or raises the existing
%      singleton*.
%
%      H = CONTROLADOR returns the handle to a new CONTROLADOR or the handle to
%      the existing singleton*.
%
%      CONTROLADOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROLADOR.M with the given input arguments.
%
%      CONTROLADOR('Property','Value',...) creates a new CONTROLADOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before controlador_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to controlador_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help controlador

% Last Modified by GUIDE v2.5 30-Nov-2019 14:45:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @controlador_OpeningFcn, ...
                   'gui_OutputFcn',  @controlador_OutputFcn, ...
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


% --- Executes just before controlador is made visible.
function controlador_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to controlador (see VARARGIN)

% Choose default command line output for controlador
handles.output = hObject;

% configurações slider / mostrar limites
min_aslider = get(handles.slider_a_value, 'Min');
max_aslider = get(handles.slider_a_value, 'Max');
set(handles.text_slider_min, 'String', num2str(min_aslider));
set(handles.text_slider_max, 'String', num2str(max_aslider));

min_qslider = get(handles.slider_q_value, 'Min');
max_qslider = get(handles.slider_q_value, 'Max');
set(handles.text_slider_qmin, 'String', num2str(min_qslider));
set(handles.text_slider_qmax, 'String', num2str(max_qslider));

% plot inicial
a_inicial = 0;
q_inicial = 1;
precisao_a = 3;
precisao_q = 3;
data1 = struct('a_value', a_inicial, 'q_value', q_inicial, 'a_precision', precisao_a, 'q_precision', precisao_q);
setappdata(handles.fig_controlador, 'ControlData', data1);
plotar(a_inicial, q_inicial, handles, 0);

% mostrar valor inicial slider
set(handles.edit_a_value,'String',num2str(round(get(handles.slider_a_value,'Value'), precisao_a)));
set(handles.edit_q_value,'String',num2str(round(get(handles.slider_q_value,'Value'), precisao_q)));

% sempre atualizar o valor do slider
% https://www.mathworks.com/matlabcentral/answers/264979-continuous-slider-callback-how-to-get-value-from-addlistener
% https://stackoverflow.com/questions/6032924/in-matlab-how-can-you-have-a-callback-execute-while-a-slider-is-being-dragged
% https://www.mathworks.com/matlabcentral/answers/345396-how-to-update-an-edit-box-window-continuously-by-dragging-a-slider-in-matlab-gui
fun = @(~,~)set(handles.edit_a_value,'String',num2str(round(get(handles.slider_a_value,'Value'), 2)));
addlistener(handles.slider_a_value, 'Value', 'PostSet', fun);
% addlistener(handles.slider_a_value, 'Value', 'PostSet', @(hObject, eventdata)slider_a(hObject, eventdata));

fun1 = @(~,~)set(handles.edit_q_value,'String',num2str(round(get(handles.slider_q_value,'Value'), 2)));
addlistener(handles.slider_q_value, 'Value', 'PostSet', fun1);
% addlistener(handles.slider_q_value, 'Value', 'PostSet', @(hObject, eventdata)slider_q(hObject, eventdata));

% configuração do plot de estabilidade
x_min = -4;
x_max = 4;
y_min = x_min;
y_max = x_max;
set(handles.plot_estabilidade, 'XLim', [x_min, x_max], 'YLim', [y_min, y_max]);

% estado inicial
set(handles.slider_a_value, 'enable', 'on');
set(handles.edit_set_a, 'enable', 'off');
set(handles.edit_a_value, 'enable', 'inactive');
set(handles.slider_q_value, 'enable', 'on');
set(handles.edit_set_q, 'enable', 'off');
set(handles.edit_q_value, 'enable', 'inactive');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes controlador wait for user response (see UIRESUME)
% uiwait(handles.fig_controlador);


% --- Outputs from this function are returned to the command line.
function varargout = controlador_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                          FUNÇÕES CRIADAS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function slider_a(hObject, eventdata)
GUI1    = findobj(allchild(groot), 'flat', 'Tag', 'fig_controlador');
handles = guidata(GUI1);
% handles = guidata(hObject);
if (get(handles.checkbox_a_value, 'value') == 0)

    P = getappdata(handles.fig_controlador, 'ControlData');
    precisao = P.a_precision;

    a = round(get(handles.slider_a_value, 'value'), precisao);
    set(handles.edit_a_value,'String',num2str(a));
    
    ControlData = getappdata(handles.fig_controlador, 'ControlData');
    q = ControlData.q_value;
    ControlData.a_value = a;
    setappdata(handles.fig_controlador, 'ControlData', ControlData);

    plotar(a, q, handles, 0);
end 

function slider_q(hObject, eventdata)
GUI1    = findobj(allchild(groot), 'flat', 'Tag', 'fig_controlador');
handles = guidata(GUI1);
% handles = guidata(hObject);
if (get(handles.checkbox_q_value, 'value') == 0)

    P = getappdata(handles.fig_controlador, 'ControlData');
    precisao = P.q_precision;

    q = round(get(handles.slider_q_value, 'value'), precisao);
    set(handles.edit_q_value,'String',num2str(q));
    
    ControlData = getappdata(handles.fig_controlador, 'ControlData');
    a = ControlData.a_value;
    ControlData.q_value = q;
    setappdata(handles.fig_controlador, 'ControlData', ControlData);

    plotar(a, q, handles, 0);
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                      CRIAÇÃO DOS COMPONENTES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function slider_a_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_a_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Propriedades do slider
min_slider = -1;
max_slider = 2;
set(hObject, 'Min', min_slider, 'Max', max_slider);

%  Specify SliderStep as a two-element vector, [minor_step major_step]
slider_step = ones(1, 2);
slider_step(1) = 0.1/(max_slider - min_slider);
slider_step(2) = 0.1/(max_slider - min_slider);
set(hObject, 'SliderStep' , slider_step);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function slider_q_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_q_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Propriedades do slider
min_slider = 0;
max_slider = 1;
set(hObject, 'Min', min_slider, 'Max', max_slider);

%  Specify SliderStep as a two-element vector, [minor_step major_step]
slider_step = ones(1, 2);
slider_step(1) = 0.1/(max_slider - min_slider);
slider_step(2) = 0.1/(max_slider - min_slider);
set(hObject, 'SliderStep' , slider_step);

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                            CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on slider movement.
function slider_a_value_Callback(hObject, eventdata, handles)
% hObject    handle to slider_a_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% if (get(handles.button_start, 'value') == 1)
   if (get(handles.checkbox_a_value, 'value') == 0)
        
        P = getappdata(handles.fig_controlador, 'ControlData');
        precisao = P.a_precision;

        a = round(get(hObject, 'value'), precisao);

        ControlData = getappdata(handles.fig_controlador, 'ControlData');
        q = ControlData.q_value;
        ControlData.a_value = a;
        setappdata(handles.fig_controlador, 'ControlData', ControlData);

        plotar(a, q, handles, 0);

   end 
% end 


function edit_set_a_Callback(hObject, eventdata, handles)
% hObject    handle to edit_set_a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_set_a as text
%        str2double(get(hObject,'String')) returns contents of edit_set_a as a double
% if (get(handles.button_start, 'value') == 1)
   if (get(handles.checkbox_a_value, 'value') == 1)
        
        P = getappdata(handles.fig_controlador, 'ControlData');
        precisao = P.a_precision;
        
        a = round(str2double(get(hObject, 'string')), precisao);

        % str2double function returns NaN for nonnumeric input.
        if isnan(a)
            errordlg('You must enter a numeric value','Invalid Input','modal')
%             uicontrol(hObject)
            return
        end
        
        ControlData = getappdata(handles.fig_controlador, 'ControlData');
        q = ControlData.q_value;
        ControlData.a_value = a;
        setappdata(handles.fig_controlador, 'ControlData', ControlData);
        
        plotar(a, q, handles, 0);
        
   end 
% end

% --- Executes on slider movement.
function slider_q_value_Callback(hObject, eventdata, handles)
% hObject    handle to slider_q_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% if (get(handles.button_start, 'value') == 1)
   if (get(handles.checkbox_q_value, 'value') == 0)
        
        P = getappdata(handles.fig_controlador, 'ControlData');
        precisao = P.q_precision;
        
        q = round(get(hObject, 'value'), precisao);
        
        ControlData = getappdata(handles.fig_controlador, 'ControlData');
        a = ControlData.a_value;
        ControlData.q_value = q;
        setappdata(handles.fig_controlador, 'ControlData', ControlData);
        
        plotar(a, q, handles, 0);

   end 
% end 

function edit_set_q_Callback(hObject, eventdata, handles)
% hObject    handle to edit_set_q (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_set_q as text
%        str2double(get(hObject,'String')) returns contents of edit_set_q as a double
% if (get(handles.button_start, 'value') == 1)
   if (get(handles.checkbox_q_value, 'value') == 1)
        
        P = getappdata(handles.fig_controlador, 'ControlData');
        precisao = P.q_precision;
        
        q = round(str2double(get(hObject, 'string')), precisao);

        % str2double function returns NaN for nonnumeric input.
        if isnan(q)
            errordlg('You must enter a numeric value','Invalid Input','modal')
%             uicontrol(hObject)
            return
        end
        
        ControlData = getappdata(handles.fig_controlador, 'ControlData');
        a = ControlData.a_value;
        ControlData.q_value = q;
        setappdata(handles.fig_controlador, 'ControlData', ControlData);
        
        plotar(a, q, handles, 0);
        
   end 
% end 

% --- Executes on button press in checkbox_a_value.
function checkbox_a_value_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_a_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_a_value
check = get(hObject,'Value');

if (check == 1)
    set(handles.slider_a_value, 'enable', 'off');
    set(handles.edit_set_a, 'enable', 'on');
    set(handles.edit_a_value, 'enable', 'off');
else
    set(handles.slider_a_value, 'enable', 'on');
    set(handles.edit_set_a, 'enable', 'off');
    set(handles.edit_a_value, 'enable', 'inactive');
end 

% --- Executes on button press in checkbox_q_value.
function checkbox_q_value_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_q_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_q_value
check = get(hObject,'Value');

if (check == 1)
    set(handles.slider_q_value, 'enable', 'off');
    set(handles.edit_set_q, 'enable', 'on');
    set(handles.edit_q_value, 'enable', 'off');
else
    set(handles.slider_q_value, 'enable', 'on');
    set(handles.edit_set_q, 'enable', 'off');
    set(handles.edit_q_value, 'enable', 'inactive');
end  

% --- Executes on button press in button_save.
function button_save_Callback(hObject, eventdata, handles)
% hObject    handle to button_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ControlData = getappdata(handles.fig_controlador, 'ControlData');
a = ControlData.a_value;
q = ControlData.q_value;

path = get(handles.edit_save, 'string');
if (isempty(path) || ~exist(path, 'dir'))
    errordlg('Invalid Directory','Invalid Input','modal');
    return 
end 

if isempty(findobj(allchild(groot), 'flat', 'tag', 'fig_control_salvar'))
    controlador_salvar;
    handles2 = guihandles(controlador_salvar);
    
    lim_x = get(handles.plot_estabilidade, 'XLim');
    lim_y = get(handles.plot_estabilidade, 'YLim');
    set(handles2.plot_estabilidade, 'XLim', lim_x, 'YLim', lim_y);
    plotar(a, q, handles2, 1);
    
    msgbox('Operation Completed!','Success');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                               MENU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://www.mathworks.com/help/matlab/graphics-objects.html
% https://www.mathworks.com/matlabcentral/answers/463232-multi-window-gui-single-file
% https://www.mathworks.com/matlabcentral/answers/147242-collecting-user-inputs-with-multiple-gui-windows
% https://www.mathworks.com/matlabcentral/answers/13482-help-with-multi-window-gui
% https://www.mathworks.com/matlabcentral/answers/167461-using-a-main-gui-window-to-open-new-ones
% https://www.mathworks.com/matlabcentral/answers/310185-opening-another-figure-doesn-t-create-handles-in-guide-how-to-fix-it
% https://www.youtube.com/watch?v=-ONffXoS47g

% --------------------------------------------------------------------
function menu_config_Callback(hObject, eventdata, handles)
% hObject    handle to menu_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function config_slider_Callback(hObject, eventdata, handles)
% hObject    handle to config_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(findobj(allchild(groot), 'flat', 'tag', 'fig_config_slider'))
    config_slider;
    handles2 = guihandles(config_slider);

    % fig2 = openfig('config_slider.fig');
    % handles2 = guihandles(fig2);

    % Propriedades do slider
    a_slider_min = get(handles.slider_a_value, 'Min');
    a_slider_max = get(handles.slider_a_value, 'Max');
    a_slider_step = get(handles.slider_a_value, 'SliderStep'); %[minor_step major_step]
    set(handles2.edit_a_min, 'string', num2str(a_slider_min));
    set(handles2.edit_a_min, 'value', a_slider_min);
    set(handles2.edit_a_max, 'string', num2str(a_slider_max));
    set(handles2.edit_a_max, 'value', a_slider_max);
    set(handles2.edit_a_step, 'string', num2str(a_slider_step(1)*(a_slider_max - a_slider_min)));
    set(handles2.edit_a_step, 'value', a_slider_step(1));

    q_slider_min = get(handles.slider_q_value, 'Min');
    q_slider_max = get(handles.slider_q_value, 'Max');
    q_slider_step = get(handles.slider_q_value, 'SliderStep'); %[minor_step major_step]
    set(handles2.edit_q_min, 'string', num2str(q_slider_min));
    set(handles2.edit_q_min, 'value', q_slider_min);
    set(handles2.edit_q_max, 'string', num2str(q_slider_max));
    set(handles2.edit_q_max, 'value', q_slider_max);
    set(handles2.edit_q_step, 'string', num2str(q_slider_step(1)*(q_slider_max - q_slider_min)));
    set(handles2.edit_q_step, 'value', q_slider_step(1));
    
    P = getappdata(handles.fig_controlador, 'ControlData');
    precisao_a = P.a_precision;
    precisao_q = P.q_precision;
    set(handles2.edit_a_precision, 'string', num2str(precisao_a));
    set(handles2.edit_a_precision, 'value', precisao_a);
    set(handles2.edit_q_precision, 'string', num2str(precisao_q));
    set(handles2.edit_q_precision, 'value', precisao_q);

    guidata(config_slider, handles2);

end


% --------------------------------------------------------------------
function config_plot_Callback(hObject, eventdata, handles)
% hObject    handle to config_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(findobj(allchild(groot), 'flat', 'tag', 'fig_config_plot_control'))
    config_plot_control;
    handles2 = guihandles(config_plot_control);

    % fig2 = openfig('config_slider.fig');
    % handles2 = guihandles(fig2);

    % Propriedades do plot
    lim_x = get(handles.plot_estabilidade, 'XLim');
    lim_y = get(handles.plot_estabilidade, 'YLim');
    set(handles2.edit_x_min, 'string', num2str(lim_x(1)));
    set(handles2.edit_x_min, 'value', lim_x(1));
    set(handles2.edit_x_max, 'string', num2str(lim_x(2)));
    set(handles2.edit_x_max, 'value', lim_x(2));
    
    set(handles2.edit_y_min, 'string', num2str(lim_y(1)));
    set(handles2.edit_y_min, 'value', lim_y(1));
    set(handles2.edit_y_max, 'string', num2str(lim_y(2)));
    set(handles2.edit_y_max, 'value', lim_y(2));
    
    guidata(config_plot_control, handles2);

end
