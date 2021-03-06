function varargout = tom_HT_filebrowser(varargin)

% Edit the above text to modify the response to help tom_HT_filebrowser

% Last Modified by GUIDE v2.5 03-Jul-2007 16:35:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tom_HT_filebrowser_OpeningFcn, ...
                   'gui_OutputFcn',  @tom_HT_filebrowser_OutputFcn, ...
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

% -------------------------------------------------------------------------
% Opening function
% -------------------------------------------------------------------------
function tom_HT_filebrowser_OpeningFcn(hObject, eventdata, handles, varargin)

if nargin == 4
    handles.projectstruct = varargin{1};
else
    error('This GUI must be called from tom_HT_main.');
end

set(gcf,'CurrentAxes',handles.filepreview);
axis off;

handles.output = hObject;
guidata(hObject, handles);


% -------------------------------------------------------------------------
% Output function
% -------------------------------------------------------------------------
function varargout = tom_HT_filebrowser_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% -------------------------------------------------------------------------
% item type select box
% -------------------------------------------------------------------------
function popupmenu_itemtype_Callback(hObject, eventdata, handles)

contents = get(hObject,'String');
itemtype = contents{get(hObject,'Value')};

switch lower(itemtype)
    
    case 'micrographs'
        result = tom_HT_getmicrographgroups(handles.projectstruct);
        if ~isempty(result)
            set(handles.popupmenu_itemdetailselection,'String',result.name);
            set(handles.text_itemtype,'String','Series:');
            set(handles.popupmenu_itemdetailselection,'Visible','on');
        else
            set(handles.popupmenu_itemdetailselection,'Visible','off');
            set(handles.text_itemtype,'String','');
            [icon,colormap] = tom_HT_geticon('error',64);
            msgbox('No micrograph groups defined. Define a micrograph group first.','Error','custom',icon,colormap,'modal');
            error('No micrograph groups defined. Define a micrograph group first.');
        end

    otherwise
        set(handles.popupmenu_itemdetailselection,'Visible','off');
        set(handles.text_itemtype,'String','');
        
end

guidata(hObject, handles);


% -------------------------------------------------------------------------
% detail select box
% -------------------------------------------------------------------------
function popupmenu_itemdetailselection_Callback(hObject, eventdata, handles)

contents = get(handles.popupmenu_itemtype,'String');
itemtype = contents{get(handles.popupmenu_itemtype,'Value')};

contents = get(hObject,'String');
detailselection = contents{get(hObject,'Value')};

switch lower(itemtype)
    case 'micrographs'
        handles.itemobject = tom_HT_imageseries(handles.projectstruct,detailselection);
        filenames = get_filenames(handles.itemobject);
        set(handles.listbox_itemselection,'String',filenames);
end

guidata(hObject, handles);


% -------------------------------------------------------------------------
% item list box
% -------------------------------------------------------------------------
function listbox_itemselection_Callback(hObject, eventdata, handles)

settings = tom_HT_settings();

contents = get(handles.popupmenu_itemtype,'String');
itemtype = contents{get(handles.popupmenu_itemtype,'Value')};

contents = get(hObject,'String');
selectedfile = contents{get(hObject,'Value')};

switch lower(itemtype)
    case 'micrographs'
        image = getmicrograph(handles.itemobject,selectedfile,1,660);
        origsize = get(image,'origsize');
        stat = get(image,'stat');
        Header = get(image,'header');
        textstruct(1).name = 'Size';
        textstruct(1).value = [num2str(origsize(1)) ' x ' num2str(origsize(2))];
        textstruct(2).name = 'Date';
        
        textstruct(2).value = Header.Date;
        textstruct(3).name = 'Object Pixel size';
        textstruct(3).value = Header.Objectpixelsize;
        textstruct(4).name = 'Intended defocus value';
        textstruct(4).value = Header.Defocus;
        textstruct(5).name = 'Voltage';
        textstruct(5).value = Header.Voltage;
        textstruct(6).name = 'Cs';
        textstruct(6).value = Header.Cs;
        textstruct(7).name = 'min';
        textstruct(7).value = stat.min;
        textstruct(8).name = 'max';
        textstruct(8).value = stat.max;
        textstruct(9).name = 'mean';
        textstruct(9).value = stat.mean;
        textstruct(10).name = 'std';
        textstruct(10).value = stat.std;
        textstruct(11).name = 'variance';
        textstruct(11).value = stat.variance;     
end
set(gcf,'CurrentAxes',handles.filepreview);
disp_image(image);

set(handles.text_metainfo,'String',tom_HT_formattextfield(textstruct));

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Button View
% -------------------------------------------------------------------------
function button_view_Callback(hObject, eventdata, handles)

settings = tom_HT_settings();

contents = get(handles.popupmenu_itemtype,'String');
itemtype = contents{get(handles.popupmenu_itemtype,'Value')};

contents = get(handles.listbox_itemselection,'String');
selectedfile = contents{get(handles.listbox_itemselection,'Value')};

switch lower(itemtype)
    case 'micrographs'
        image = getmicrograph(handles.itemobject,selectedfile,1);
        imtool(image.Value',[image.stat.mean-(2.*image.stat.std) image.stat.mean+(2.*image.stat.std)],'InitialMagnification','fit');
end

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Edit meta info
% -------------------------------------------------------------------------
function button_editmetainfo_Callback(hObject, eventdata, handles)

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Button Copy to Work space
% -------------------------------------------------------------------------
function button_copytows_Callback(hObject, eventdata, handles)

settings = tom_HT_settings();

contents = get(handles.popupmenu_itemtype,'String');
itemtype = contents{get(handles.popupmenu_itemtype,'Value')};

contents = get(handles.listbox_itemselection,'String');
selectedfile = contents{get(handles.listbox_itemselection,'Value')};

switch lower(itemtype)
    case 'micrographs'
    image = getmicrograph(handles.itemobject,selectedfile);
    copytows(image,'micrograph');
end

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Copy to Work space
% -------------------------------------------------------------------------
function copytows(var,varname)

var_base = cellstr(evalin('base','who(''-regexp'', ''micrograph_*'')'));
[xx,varnum] = strtok(var_base,'_');
varnum2 = zeros(size(varnum,1),1);

for i=1:size(varnum,1); 
    temp = varnum{i}; 
    varnum2(i) = str2double(temp(2:end)); 
end

if isempty(varnum2)
    varnum2 = 0;
end

assignin('base',[varname '_' num2str(max(varnum2)+1)],var);


% -------------------------------------------------------------------------
% Create functions
% -------------------------------------------------------------------------
function popupmenu_itemtype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_itemselection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupmenu_itemdetailselection_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
