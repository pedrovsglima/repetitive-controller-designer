function varargout = filtro(varargin)
% FILTRO MATLAB code for filtro.fig
%      FILTRO, by itself, creates a new FILTRO or raises the existing
%      singleton*.
%
%      H = FILTRO returns the handle to a new FILTRO or the handle to
%      the existing singleton*.
%
%      FILTRO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTRO.M with the given input arguments.
%
%      FILTRO('Property','Value',...) creates a new FILTRO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filtro_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filtro_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filtro

% Last Modified by GUIDE v2.5 28-Nov-2022 17:16:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filtro_OpeningFcn, ...
                   'gui_OutputFcn',  @filtro_OutputFcn, ...
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

% --- Executes just before filtro is made visible.
function filtro_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filtro (see VARARGIN)

% Choose default command line output for filtro
handles.output = hObject;

% default plot
x_min1 = 1e-6;
x_max1 = 1e6;
y_min1 = 0;
y_max1 = 1.1;
axes(handles.plot_filtro);
xlabel('Frequency (Hz)');
ylabel('Q(j\omega) (abs)');
set(handles.plot_filtro, 'XLim', [x_min1, x_max1], 'YLim', [y_min1, y_max1]);
grid on;

% define sampling rate (if not already done)
GUI1        = findobj(allchild(groot), 'flat', 'Tag', 'fig_main');
handlesGUI1 = guidata(GUI1);
PlantData = getappdata(handlesGUI1.fig_main, 'PlantData');
ts = PlantData.ts;
if (ts == 0)
    set(handles.edit_fs, 'enable', 'on');
else
    set(handles.edit_fs, 'string', num2str(1/ts, 2));
    set(handles.edit_fs, 'enable', 'off');
end

% initial values
set(handles.edit_q_init, 'value', 1);
set(handles.edit_q_step, 'value', 0.05);
set(handles.edit_f_init, 'value', -6);
set(handles.edit_f_fin, 'value', 6);
set(handles.edit_f_step, 'value', 100);
set(handles.edit_a_filtro, 'value', 0);

% initial state
set(handles.button_ws, 'enable', 'off');

% data to send to workspace
data = struct('freq', [], 'q_value', [], 'ordem', 0, 'corte', 0, 'sampling', 0, 'fir_coefs', []);
setappdata(handles.fig_filtro, 'FilterData', data);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = filtro_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in button_filtro.
function button_filtro_Callback(hObject, eventdata, handles)
% hObject    handle to button_filtro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% sampling frequency is a must-have
GUI1        = findobj(allchild(groot), 'flat', 'Tag', 'fig_main');
handlesGUI1 = guidata(GUI1);
PlantData = getappdata(handlesGUI1.fig_main, 'PlantData');
ts = PlantData.ts;

% Hint: get(hObject,'Value') returns toggle state of button_filtro
if (~get(hObject, 'value'))
    % button name
    set(hObject, 'string', 'Run');
    set(handles.button_ws, 'enable', 'off');
    
    % can make changes until the 'run' button is pressed
    set(handles.edit_q_step, 'enable', 'on');
    set(handles.edit_f_step, 'enable', 'on');
    set(handles.edit_a_filtro, 'enable', 'on');
    set(handles.edit_q_init, 'enable', 'on');
    set(handles.edit_f_init, 'enable', 'on');
    set(handles.edit_f_fin, 'enable', 'on');
    set(handles.listbox_filtro, 'enable', 'on');   
    
    % define sampling rate (if not already done)
    if (ts == 0)
        set(handles.edit_fs, 'enable', 'on');
    else
        set(handles.edit_fs, 'string', num2str(1/ts, 2));
        set(handles.edit_fs, 'enable', 'off');
    end
    
    % results
    set(handles.edit_ordem, 'string', '-');
    set(handles.edit_corte, 'string', '-');
    
    % clear plot
    lim_x = get(handles.plot_filtro, 'XLim');
    lim_y = get(handles.plot_filtro, 'YLim');
    
    axes(handles.plot_filtro);
    semilogx(0, 0);
     
    check_type = get(handles.listbox_filtro, 'value');
    if (check_type == 1)
        eixo_y = 'Q(j\omega) (abs)';
        set(handles.plot_filtro, 'XLim', [lim_x(1), lim_x(2)], 'YLim', [0, lim_y(2)]);
    elseif (check_type == 2)
        eixo_y = 'Q(j\omega) (dB)';
        set(handles.plot_filtro, 'XLim', [lim_x(1), lim_x(2)], 'YLim', [mag2db(0.01), mag2db(lim_y(2))]);
    end
    
    xlabel('Frequency (Hz)');
    ylabel(eixo_y);
    grid on;
    
else
    
    % run algorithm after checking input values
    q_init = str2num(get(handles.edit_q_init, 'string'));
    [q_initRows, q_initCols] = size(q_init);
    if (isempty(q_init) || q_initRows ~= 1 || q_initCols ~= 1)
        errordlg('"Initial Value" of Q must be a number','Invalid Input','modal');
        return 
    end
    
    q_step = str2num(get(handles.edit_q_step, 'string'));
    [q_stepRows, q_stepCols] = size(q_step);
    if (isempty(q_step) || q_stepRows ~= 1 || q_stepCols ~= 1)
        errordlg('Q "Step" must be a number','Invalid Input','modal');
        return 
    end
    
    if q_step >= q_init
        errordlg('"Initial Value" of Q must be greater than its "Step"','Invalid Input','modal');
        return
    end 
    
    f_init = str2num(get(handles.edit_f_init, 'string'));
    [f_initRows, f_initCols] = size(f_init);
    if (isempty(f_init) || f_initRows ~= 1 || f_initCols ~= 1)
        errordlg('"Initial Value" of Frequency must be a number','Invalid Input','modal');
        return 
    end
    
    f_fin = str2num(get(handles.edit_f_fin, 'string'));
    [f_finRows, f_finCols] = size(f_fin);
    if (isempty(f_fin) || f_finRows ~= 1 || f_finCols ~= 1)
        errordlg('"Final Value" of Frequency must be a number','Invalid Input','modal');
        return 
    end
    
    if f_init >= f_fin
        errordlg('"Final Value" of Frequency must be greater than its "Initial Value"','Invalid Input','modal');
        return
    end  
    
    f_step = str2num(get(handles.edit_f_step, 'string'));
    [f_stepRows, f_stepCols] = size(f_step);
    if (isempty(f_step) || f_stepRows ~= 1 || f_stepCols ~= 1 || f_step <= 0)
        errordlg('The "Number of Points" for the Frequency must be a positive number','Invalid Input','modal');
        return 
    end

    if (ts == 0)
        fs = str2num(get(handles.edit_fs, 'string'));
        [f_sRows, f_sCols] = size(fs);
        if (isempty(fs) || f_sRows ~= 1 || f_sCols ~= 1 || fs <= 0)
            errordlg('Sampling Rate must be a positive number','Invalid Input','modal');
            return 
        end
    else
        fs = 1/ts;
    end

    a = str2num(get(handles.edit_a_filtro, 'string'));
    [aRows, aCols] = size(a);
    if (isempty(a) || aRows ~= 1 || aCols ~= 1)
        errordlg('"a value" must be a number','Invalid Input','modal');
        return 
    end
          
    % button name
    set(hObject, 'string','Stop');
    set(handles.button_ws, 'enable', 'on');
    
    % cannot make changes since the 'run' button has been pressed
    set(handles.edit_q_step, 'enable', 'off');
    set(handles.edit_f_step, 'enable', 'off');
    set(handles.edit_a_filtro, 'enable', 'off');
    set(handles.edit_fs, 'enable', 'off');
    set(handles.edit_q_init, 'enable', 'off');
    set(handles.edit_f_init, 'enable', 'off');
    set(handles.edit_f_fin, 'enable', 'off');
    set(handles.listbox_filtro, 'enable', 'off');
    
    % fir filter algorithm
    freq = logspace(f_init, f_fin, f_step);
    algo_filtro(handles, q_init, q_step, freq, a, fs);
end
 
% --- Executes on button press in button_ws.
function button_ws_Callback(hObject, eventdata, handles)
% hObject    handle to button_ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

FilterData = getappdata(handles.fig_filtro, 'FilterData');

check_type = get(handles.listbox_filtro, 'value');
if (check_type == 1)
    aux_q = FilterData.q_value;
elseif (check_type == 2)
    aux_q = mag2db(FilterData.q_value);
end

data = struct('frequency', FilterData.freq, ...
              'q_value', aux_q, ...
              'order', FilterData.ordem, ...
              'cutoff_frequency', FilterData.corte, ...
              'sampling_frequency', FilterData.sampling, ...
              'fir_filter_coefficients', FilterData.fir_coefs);
       
assignin('base', 'FilterData', data);
msgbox({'Operation Completed!';'Data saved as a struct called "FilterData".'},'Success');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                         CREATED FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function algo_filtro(handles, init_q, step_q, fr, a_value, sampling_rate)
    q_init = init_q;
    q_step = step_q;
    freq = fr;        
    a = real(a_value);
        
    % get data from 'fig_main' GUI
    GUI1        = findobj(allchild(groot), 'flat', 'Tag', 'fig_main');
    handlesGUI1 = guidata(GUI1);
    
    PlantData = getappdata(handlesGUI1.fig_main, 'PlantData');
    ganho = PlantData.ganho;
    num = PlantData.num;
    den = PlantData.den;

    ft = ganho*tf(num, den, 1/sampling_rate);  
    [re, im] = nyquist(ft, 2*pi*freq);    
    
    % algorithm
    len = length(freq);
    q = q_init*ones(1, len); 
    flag = 1;
    
    mag_corte1 = 0;
    mag_corte2 = 0;
    
    for i = 1:1:len
        aux = abs(q(i))^2;
        cond = inequacao(a, aux, re(i), im(i));
        while(~cond)
            q(i:end) = q(i) - q_step;
            aux = abs(q(i))^2;
            cond = inequacao(a, aux, re(i), im(i));
        end
        % estimate slope around cutoff frequency
        if (flag == 0 && mag2db(q(i)) < -3)
            mag_corte1 = mag2db(q(i-1));
            mag_corte2 = mag2db(q(i));
            flag = 1;
        end
        % handling a possible exception when i=1
        if (i==1)
            flag=0; 
        end
    end
     
    if (mag_corte1-mag_corte2) == 0
       errordlg('Unable to design a FIR filter for the given frequency range.','Invalid Input','modal');
       return 
    else

        % find index for the highest frequency where Q = initial value
        % (just before the decay) - will be called f3dB
        q_limit = find(q < q(1));     
        f3db_index = q_limit(1) - 1;
        cutoff_freq = freq(f3db_index);
        
        filter_order = get_filter_order(sampling_rate, freq, q, f3db_index);
        
        fir_coefs = get_fir_coefs(filter_order, sampling_rate, freq(f3db_index));
        
        % save designed values for the fir filter
        FilterData = getappdata(handles.fig_filtro, 'FilterData');
        FilterData.freq = freq;
        FilterData.q_value = q;
        FilterData.ordem = filter_order;
        FilterData.corte = cutoff_freq;
        FilterData.sampling = sampling_rate;
        FilterData.fir_coefs = fir_coefs;
        setappdata(handles.fig_filtro, 'FilterData', FilterData);
        
        set(handles.edit_ordem, 'string', num2str(filter_order));
        set(handles.edit_corte, 'string', num2str(round(cutoff_freq ,2)));
      
        check_type = get(handles.listbox_filtro, 'value');
        lim_ymin = 0.9*abs(q(end));
        lim_ymax = 1.1*abs(q(1));

        axes(handles.plot_filtro);
        if (check_type == 1)
            semilogx(freq, q, 'b');
            eixo_y = 'Q(j\omega) (abs)';
            set(handles.plot_filtro, 'XLim', [freq(1), freq(end)], 'YLim', [0, lim_ymax]);
        elseif (check_type == 2)
            semilogx(freq, mag2db(q), 'b');
            eixo_y = 'Q(j\omega) (dB)';
            set(handles.plot_filtro, 'XLim', [freq(1), freq(end)], 'YLim', [mag2db(lim_ymin), mag2db(lim_ymax)]);
        end

        xlabel('Frequency (Hz)');
        ylabel(eixo_y);
        grid on;
    end    
  
function order = get_filter_order(fs, freq_values, q_values, f3db_index)
     
     % calculate the desired stopband attenuation in dB
     A_db = abs( mag2db(q_values(1) - q_values(end)) );
     
     freq = freq_values(f3db_index:end);
     q = q_values(f3db_index:end);
     
     % run algorithm to obtain the line tangent to the decay 
     % of the magnitude limit curve of Q(z)
     f_tangent = freq(1);
     q_tangent = q(1);
     for j = 0:1:length(freq)-1
         % calculate the area under the curve
         curve_area = trapz( freq(1:end-j) , ...
                               q(1:end-j) );
         
         % calculate area under a line
         % starting with the segment passing through 
         % (f3dB, 1) and (f[end], q[end])
         line_area = trapz( [freq(1), freq(end-j)], ...
                          [q(1), q(end-j)] );
         
         error = line_area - curve_area;
                 
         if (error < 0)
            f_tangent = freq(end-j);
            q_tangent = q(end-j);
%             assignin('base', 'f_tangent', f_tangent);
            break
         end
         
     end
     
     % calculate the equation of the tangent line
     a = (q_tangent - q(1)) / (f_tangent - freq(1));
     b = q(1) - a*freq(1);
     
     f_stopband = (q(end)-b)/a;
%      assignin('base', 'f_stopband', f_stopband);
     
     % calculate the transition bandwidth desired to the filter
     delta_f = f_stopband - freq(1);
%      assignin('base', 'delta_f', delta_f);
     
     % calculate filter order
     M = ceil( (A_db*fs)/(22*delta_f) );
     if mod(M, 2) ~= 0
        M = M + 1;
     end
     
     order = M;

function coefs = get_fir_coefs(order, fs, f3db)
    fn = fs/2;
    Wn = f3db/fn;
    bn = fir1(order, Wn, 'low');
    coefs = bn;