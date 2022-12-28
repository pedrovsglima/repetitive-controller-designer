function varargout = controlador_salvar(varargin)
% CONTROLADOR_SALVAR MATLAB code for controlador_salvar.fig
%      CONTROLADOR_SALVAR, by itself, creates a new CONTROLADOR_SALVAR or raises the existing
%      singleton*.
%
%      H = CONTROLADOR_SALVAR returns the handle to a new CONTROLADOR_SALVAR or the handle to
%      the existing singleton*.
%
%      CONTROLADOR_SALVAR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROLADOR_SALVAR.M with the given input arguments.
%
%      CONTROLADOR_SALVAR('Property','Value',...) creates a new CONTROLADOR_SALVAR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before controlador_salvar_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to controlador_salvar_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help controlador_salvar

% Last Modified by GUIDE v2.5 29-Nov-2019 18:41:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @controlador_salvar_OpeningFcn, ...
                   'gui_OutputFcn',  @controlador_salvar_OutputFcn, ...
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


% --- Executes just before controlador_salvar is made visible.
function controlador_salvar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to controlador_salvar (see VARARGIN)

% Choose default command line output for controlador_salvar
handles.output = hObject;

% mainfig = gcf;

set(handles.edit_freq, 'visible', 'off');
set(handles.edit_estabilidade, 'visible', 'off');

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes controlador_salvar wait for user response (see UIRESUME)
% uiwait(handles.fig_control_save);


% --- Outputs from this function are returned to the command line.
function varargout = controlador_salvar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
