function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 25-Feb-2020 17:30:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% variáveis para plot de nyquist
data = struct('real', [], 'imag', [], 'freq', []);
setappdata(handles.fig_main, 'NyquistData', data);

data2 = struct('ganho', 0, 'num', [], 'den', [], 'ts', 0);
setappdata(handles.fig_main, 'PlantData', data2);

% estado dos componentes de 'input'
set(handles.edit_gain, 'enable', 'on');
set(handles.edit_num, 'enable', 'on');
set(handles.edit_den, 'enable', 'on');
set(handles.edit_ts, 'enable', 'off');
set(handles.list_function_type, 'enable', 'on');
set(handles.edit_var, 'enable', 'off');
set(handles.edit_gain_ws, 'enable', 'off');

% deshabilitar botões
set(handles.button_control, 'enable', 'off');
set(handles.button_filtro, 'enable', 'off');

% definição valores inciais
set(handles.edit_gain_ws, 'value', 1);

% imagem do controlador
axes(handles.axes_controlador)
matlabImage = imread('control2.png');
image(matlabImage)
axis off
axis image

% imagem do 'about'
[a,~]=imread('about.png');
[r,c,~]=size(a); 
kk=ceil(r/30); 
ww=ceil(c/30); 
gg=a(1:kk:end,1:ww:end,:);
gg(gg==255)=5.5*255;
set(handles.button_about,'CData',gg);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.fig_main);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in button_start.
function button_start_Callback(hObject, eventdata, handles)
% hObject    handle to button_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button_start
state = get(hObject,'Value');
check_in = get(handles.checkbox_var,'Value');
check_type = get(handles.list_function_type, 'Value'); % 1 - Continuous / 2 - Discrete

if (state == 1)
    % se checkbox estiver marcada
    if check_in
        try 
            % https://www.mathworks.com/help/matlab/ref/evalin.html
            % https://www.mathworks.com/help/matlab/creating_guis/plot-workspace-variables-in-a-guide-gui.html
            % https://www.mathworks.com/help/matlab/matlab_prog/string-evaluation.html
            % https://www.mathworks.com/matlabcentral/answers/304528-tutorial-why-variables-should-not-be-named-dynamically-eval
            var = get(handles.edit_var, 'String');
            func = evalin('base', var);
            if (isa(func, 'tf') || isa(func, 'zpk'))
                % https://www.mathworks.com/help/control/ref/tfdata.html
                [n, d, ts] = tfdata(func);
                num = n{1};
                den = d{1};
            else
                errordlg('The chosen variable is neither a transfer function model nor a zpk model','Invalid Input','modal');
                return
            end
        catch err
%             errordlg('Variable does not exist','Invalid Input','modal');
            errordlg(err.message,'Invalid Input','modal');
            return
        end
        
        ganho = str2num(get(handles.edit_gain_ws, 'string'));
        [ganhoRows, ganhoCols] = size(ganho);
        if (isempty(ganho) || ganhoRows ~= 1 || ganhoCols ~= 1)
            errordlg('"Gain" must be a number','Invalid Input','modal');
            return 
        end
        
    % se checkbox não estiver marcada   
    else
        ganho = str2num(get(handles.edit_gain, 'string'));
        [ganhoRows, ganhoCols] = size(ganho);
        if (isempty(ganho) || ganhoRows ~= 1 || ganhoCols ~= 1)
            errordlg('"Gain" must be a number','Invalid Input','modal');
            return 
        end
        
        num = str2num(get(handles.edit_num, 'string'));
        [numRows, ~] = size(num);
        if (isempty(num) || numRows ~= 1)
            errordlg('"Numerator" must be a numeric row vector','Invalid Input','modal');
            return
        end
        
        den = str2num(get(handles.edit_den, 'string'));
        [denRows, ~] = size(den);
        if (isempty(den) || denRows ~= 1)
            errordlg('"Denominator" must be a numeric row vector','Invalid Input','modal');
            return
        end
        
        if (check_type == 2)
            ts = str2num(get(handles.edit_ts, 'string'));
            [tsRows, tsCols] = size(ts);
            if (isempty(ts) || tsRows ~= 1 || tsCols ~= 1)
                errordlg('"Ts" must be a number','Invalid Input','modal');
                return 
            end
        else
            ts = 0;
        end
    end
    
    % depois de checar a validade das entradas, executa algoritmo
    
    % nome no botão
    set(hObject, 'string','Redefine');
    
    % não permitir modificações em 'input' já que 'start' foi apertado
    set(handles.checkbox_var, 'enable', 'off');
    set(handles.edit_gain, 'enable', 'off');
    set(handles.edit_num, 'enable', 'off');
    set(handles.edit_den, 'enable', 'off');
    set(handles.edit_var, 'enable', 'off');
    set(handles.edit_gain_ws, 'enable', 'off');
    set(handles.edit_ts, 'enable', 'off');
    set(handles.list_function_type, 'enable', 'off');

    % criar ft a partir de gain, num e den
    transf_func = ganho*tf(num, den, ts);
    [r, i, wout] = nyquist(transf_func);
    
    PlantData = getappdata(handles.fig_main, 'PlantData');
    PlantData.ganho = ganho;
    PlantData.num = num;
    PlantData.den = den;
    PlantData.ts = ts;
    setappdata(handles.fig_main, 'PlantData', PlantData);
    
    re = squeeze(r);
    im = squeeze(i);
    
    NyquistData = getappdata(handles.fig_main, 'NyquistData');
    NyquistData.real = re;
    NyquistData.imag = im;
    NyquistData.freq = wout;
    setappdata(handles.fig_main, 'NyquistData', NyquistData);
    
    % habilitar botões
    set(handles.button_control, 'enable', 'on');
    set(handles.button_filtro, 'enable', 'on');
    
else
    % nome no botão
    set(hObject, 'string','OK');
    
    % fecha as janelas, caso abertas
    close(findobj('type','figure','tag','fig_controlador'));
    close(findobj('type','figure','tag','fig_filtro'));
    close(findobj('type','figure','tag','fig_config_slider'));
    close(findobj('type','figure','tag','fig_config_plot_control'));
    
    % deshabilitar botões
    set(handles.button_control, 'enable', 'off');
    set(handles.button_filtro, 'enable', 'off');
    
    % permitir modificações em 'input' até que 'start' seja apertado
    set(handles.checkbox_var, 'enable', 'on');
    if (check_in == 1)
        set(handles.edit_gain, 'enable', 'off');
        set(handles.edit_num, 'enable', 'off');
        set(handles.edit_den, 'enable', 'off');
        set(handles.edit_ts, 'enable', 'off');
        set(handles.list_function_type, 'enable', 'off');
        set(handles.edit_var, 'enable', 'on');
        set(handles.edit_gain_ws, 'enable', 'on');
    else
        set(handles.list_function_type, 'enable', 'on');
        set(handles.edit_gain, 'enable', 'on');
        set(handles.edit_num, 'enable', 'on');
        set(handles.edit_den, 'enable', 'on');        
        set(handles.edit_var, 'enable', 'off');
        set(handles.edit_gain_ws, 'enable', 'off');
        if (check_type == 1)
            set(handles.edit_ts, 'enable', 'off');
        elseif (check_type == 2)
            set(handles.edit_ts, 'enable', 'on');
        end
    end  
end  

% --- Executes on button press in button_control.
function button_control_Callback(hObject, eventdata, handles)
% hObject    handle to button_control (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(findobj(allchild(groot), 'flat', 'tag', 'fig_controlador'))
    controlador;
%     handles2 = guihandles(controlador)
end

% --- Executes on button press in button_filtro.
function button_filtro_Callback(hObject, eventdata, handles)
% hObject    handle to button_filtro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isempty(findobj(allchild(groot), 'flat', 'tag', 'fig_filtro'))
    filtro;
%     handles3 = guihandles(filtro);
end

% --- Executes on selection change in list_function_type.
function list_function_type_Callback(hObject, eventdata, handles)
% hObject    handle to list_function_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_function_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_function_type
check_type = get(hObject, 'Value');
if (check_type == 1)
    set(handles.edit_ts, 'enable', 'off');
elseif (check_type == 2)
    set(handles.edit_ts, 'enable', 'on');
end

% --- Executes on button press in checkbox_var.
function checkbox_var_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_var (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_var
check = get(hObject,'Value');

if (check == 1)
    set(handles.edit_gain, 'enable', 'off');
    set(handles.edit_num, 'enable', 'off');
    set(handles.edit_den, 'enable', 'off');
    set(handles.edit_ts, 'enable', 'off');
    set(handles.list_function_type, 'enable', 'off');
    set(handles.edit_var, 'enable', 'on');
    set(handles.edit_gain_ws, 'enable', 'on');
else
    set(handles.edit_gain, 'enable', 'on');
    set(handles.edit_num, 'enable', 'on');
    set(handles.edit_den, 'enable', 'on');
    set(handles.list_function_type, 'enable', 'on');
    set(handles.edit_var, 'enable', 'off');
    set(handles.edit_gain_ws, 'enable', 'off');
    if (get(handles.list_function_type, 'value') == 1)
        set(handles.edit_ts, 'enable', 'off');
    else
        set(handles.edit_ts, 'enable', 'on');
    end
end

% --- Executes on button press in button_about.
function button_about_Callback(hObject, eventdata, handles)
% hObject    handle to button_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(findobj(allchild(groot), 'flat', 'tag', 'fig_about'))
    about;
end
