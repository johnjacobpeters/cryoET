function varargout = tom_HT_openproject(varargin)


% Last Modified by GUIDE v2.5 22-Jun-2007 14:32:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tom_HT_openproject_OpeningFcn, ...
                   'gui_OutputFcn',  @tom_HT_openproject_OutputFcn, ...
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
function tom_HT_openproject_OpeningFcn(hObject, eventdata, handles, varargin)

%icon = tom_HT_geticon('add',16);
%set(handles.tabpanel_New_button_create,'Cdata',icon);

if nargin == 3
    handles.conn = tom_HT_opendb();

else
    handles.conn = varargin{1};
end

handles = get_projects(handles);

handles.output = hObject;
guidata(hObject, handles);


% -------------------------------------------------------------------------
% Output function
% -------------------------------------------------------------------------
function varargout = tom_HT_openproject_OutputFcn(hObject, eventdata, handles) 


varargout{1} = handles.output;


% -------------------------------------------------------------------------
% Open / button select
% -------------------------------------------------------------------------
function tabpanel_Open_button_select_Callback(hObject, eventdata, handles)

contents = get(handles.tabpanel_Open_openproject,'String');
project = contents{get(handles.tabpanel_Open_openproject,'Value')};

result = fetch(handles.conn,['SELECT project_id FROM projects WHERE name = ''' project ''''],1);

tom_HT_main(handles.conn,result.project_id);
close(handles.figure1);


% -------------------------------------------------------------------------
% Open / project selection
% -------------------------------------------------------------------------
function tabpanel_Open_popupmenu_openproject_Callback(hObject, eventdata, handles)

contents = get(hObject,'String');
project = contents{get(hObject,'Value')};


handles = show_project(handles,project);


guidata(hObject, handles);


% -------------------------------------------------------------------------
% New / button create new project
% -------------------------------------------------------------------------
function tabpanel_New_button_create_Callback(hObject, eventdata, handles)

name = get(handles.tabpanel_New_edit_projectname,'String');
datadir = get(handles.tabpanel_New_edit_datadir,'String');
description = tom_HT_serialize_string(get(handles.tabpanel_New_edit_comment,'String'));

if isempty(name)
    [icon,colormap] = tom_HT_geticon('error',64);
    msgbox('Enter project name.','Error','custom',icon,colormap,'modal');
    guidata(hObject, handles);
    return;
end

if isempty(datadir)
    [icon,colormap] = tom_HT_geticon('error',64);
    msgbox('Enter data directory.','Error','custom',icon,colormap,'modal');
    guidata(hObject, handles);
    return;
end

result = exec(handles.conn,['SELECT project_id FROM projects WHERE name = ''' name ''' OR datadir = ''' datadir '''']);
result = fetch(result, 1);
if rows(result) > 0
    [icon,colormap] = tom_HT_geticon('error',64);
    msgbox('The name or data directory does already exist.','Error','custom',icon,colormap,'modal');
    guidata(hObject, handles);
    return;
end


tom_HT_createprojectdir(datadir);

fastinsert(handles.conn, 'projects', {'name','description','datadir'}, {name,description,datadir});

handles = get_projects(handles);

[icon,colormap] = tom_HT_geticon('ok',64);
msgbox('Project created.','Success','custom',icon,colormap,'modal');

set(handles.tabpanel_New_edit_projectname,'String','');
set(handles.tabpanel_New_edit_datadir,'String','');
set(handles.tabpanel_New_edit_comment,'String','');

guidata(hObject, handles);


% -------------------------------------------------------------------------
% get projects from database and update dropdown menu
% -------------------------------------------------------------------------
function handles = get_projects(handles)

result = fetch(handles.conn,'SELECT name FROM projects');

if ~isempty(result)
    set(handles.tabpanel_Open_openproject,'String',result.name);
else
    set(handles.tabpanel_Open_openproject,'String','--no projects defined--');
end


% -------------------------------------------------------------------------
% show project details in textbox
% -------------------------------------------------------------------------
function handles = show_project(handles,name)

result = fetch(handles.conn,['SELECT description FROM projects WHERE name = ''' name '''']);

set(handles.tabpanel_Open_text_projectcomment,'String',tom_HT_unserialize_string(result.description{1}));
    

% -------------------------------------------------------------------------
% create functions
% -------------------------------------------------------------------------
function tabpanel_New_edit_comment_Callback(hObject, eventdata, handles)
function tabpanel_New_edit_datadir_Callback(hObject, eventdata, handles)
function tabpanel_New_edit_projectname_Callback(hObject, eventdata, handles)

function tabpanel_Open_popupmenu_openproject_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function tabpanel_New_edit_comment_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function tabpanel_New_edit_datadir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function tabpanel_New_edit_projectname_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


