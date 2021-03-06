function varargout = tom_HT_micrographs(varargin)



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tom_HT_micrographs_OpeningFcn, ...
                   'gui_OutputFcn',  @tom_HT_micrographs_OutputFcn, ...
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
function tom_HT_micrographs_OpeningFcn(hObject, eventdata, handles, varargin)

if nargin == 4
    handles.projectstruct = varargin{1};
else
    error('This GUI must be called from tom_HT_main.');
end

result = tom_HT_getmicrographgroups(handles.projectstruct);
if ~isempty(result)
    set(handles.tabpanel_Insert_micrographgroups,'String',result.name);
else
    [icon,colormap] = tom_HT_geticon('error',64);
    msgbox('No micrograph groups defined. Define a micrograph group first.','Error','custom',icon,colormap,'modal');
    error('No micrograph groups defined. Define a micrograph group first.');
end

handles = get_names(handles);

handles.output = hObject;
guidata(hObject, handles);


% -------------------------------------------------------------------------
% Output function
% -------------------------------------------------------------------------
function varargout = tom_HT_micrographs_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% -------------------------------------------------------------------------
% Close figure
% -------------------------------------------------------------------------
function button_close_Callback(hObject, eventdata, handles)

close(handles.mtfs);


% -------------------------------------------------------------------------
% Insert / Browse for mtf file
% -------------------------------------------------------------------------
function tabpanel_Insert_browse_Callback(hObject, eventdata, handles)

directoryname = uigetdir(pwd, 'Pick a Directory with EM files');

if ~isempty(directoryname)
    set(handles.tabpanel_Insert_dirname,'String',directoryname);
end

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Insert / Save
% -------------------------------------------------------------------------
function tabpanel_Insert_save_Callback(hObject, eventdata, handles)

dirname = get(handles.tabpanel_Insert_dirname,'String');

contents = get(handles.tabpanel_Insert_micrographgroups,'String');
micrographseries = contents{get(handles.tabpanel_Insert_micrographgroups,'Value')};

if isempty(dirname)
    [icon,colormap] = tom_HT_geticon('error',64);
    msgbox('Enter directory name.','Error','custom',icon,colormap,'modal');
    guidata(hObject, handles);
    return;
end

if isdir(dirname) == 0
    [icon,colormap] = tom_HT_geticon('error',64);
    msgbox('Directory does not exist or is not readable.','Error','custom',icon,colormap,'modal');
    guidata(hObject, handles);
    return;
end

result = fetch(handles.projectstruct.conn,['SELECT micrographgroup_id FROM micrograph_groups WHERE name = ''' micrographseries '''']);

tom_HT_importmicrographs(handles.projectstruct,dirname,result.micrographgroup_id,1);

[icon,colormap] = tom_HT_geticon('ok',64);
msgbox('Micrographs imported.','Success','custom',icon,colormap,'modal');

set(handles.tabpanel_Insert_dirname,'String','');

handles = get_names(handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Delete / Delete
% -------------------------------------------------------------------------
function tabpanel_Delete_delete_Callback(hObject, eventdata, handles)

contents = get(handles.tabpanel_Delete_selectiondelete,'String');
name = contents{get(handles.tabpanel_Delete_selectiondelete,'Value')};

exec(handles.projectstruct.conn,['DELETE FROM micrographs WHERE name = ''' name '''']);

[icon,colormap] = tom_HT_geticon('ok',64);
msgbox('micrograph deleted.','Success','custom',icon,colormap,'modal');

handles = get_names(handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Delete / Selection box 
% -------------------------------------------------------------------------
function tabpanel_Delete_selectiondelete_Callback(hObject, eventdata, handles)

contents = get(hObject,'String');
name = contents{get(hObject,'Value')};
handles = show_data(handles,name);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% View / View Table
% -------------------------------------------------------------------------
function tabpanel_View_displaytable_Callback(hObject, eventdata, handles)

setdbprefs('DataReturnFormat','cellarray');
result = fetch(handles.projectstruct.conn,['SELECT micrograph_id,name,filename,date FROM micrographs WHERE projects_project_id = ''' num2str(handles.projectstruct.projectid) '''']);
setdbprefs('DataReturnFormat','structure');

result_header = {'mtf_id','name','filename','date'};
figure;
createTable(gcf,result_header,result,0,'Editable',false);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% get names of rows in database table
% -------------------------------------------------------------------------
function handles = get_names(handles)

% result = fetch(handles.projectstruct.conn,'SELECT name FROM micrographs');
% if ~isempty(result)
%     set(handles.tabpanel_Delete_selectiondelete,'String',result.name);
% else
%     set(handles.tabpanel_Delete_selectiondelete,'String','---no micrographs defined---');
% end


% -------------------------------------------------------------------------
% show project details in textbox
% -------------------------------------------------------------------------
function handles = show_data(handles,name)

result = fetch(handles.projectstruct.conn,['SELECT filename FROM micrographs WHERE name = ''' name ''' AND projects_project_id = ''' num2str(handles.projectstruct.projectid) '''']);
if ~isempty(result)
     string = ['filename: ' result.filename{1} ];
else
    string = '';
end

set(handles.tabpanel_Delete_deletetext,'String',string);


% -------------------------------------------------------------------------
% Create Functions
% -------------------------------------------------------------------------
function tabpanel_Insert_dirname_Callback(hObject, eventdata, handles)
function tabpanel_Delete_selectiondelete_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function tabpanel_Insert_dirname_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function tabpanel_Insert_imageseries_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function tabpanel_Insert_imageseries_Callback(hObject, eventdata, handles)




