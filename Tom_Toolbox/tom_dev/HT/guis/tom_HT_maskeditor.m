function varargout = tom_HT_maskeditor(varargin)



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tom_HT_maskeditor_OpeningFcn, ...
                   'gui_OutputFcn',  @tom_HT_maskeditor_OutputFcn, ...
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
function tom_HT_maskeditor_OpeningFcn(hObject, eventdata, handles, varargin)

if nargin == 4
    handles.projectstruct = varargin{1};
else
    error('This GUI must be called from tom_HT_main.');
end

handles.output = hObject;

set(handles.figure_maskeditor,'CurrentAxes',handles.maskaxes);
axis off;axis image;
set(handles.figure_maskeditor,'CurrentAxes',handles.previewaxes);
axis off;axis image;
set(handles.figure_maskeditor,'CurrentAxes',handles.referenceaxes);
axis off;axis image;
set(handles.drawpanel,'SelectionChangeFcn',@parametermanager);

handles.firstclick = true;

set(handles.text_param1,'Visible','on','String','center x');
set(handles.text_param2,'Visible','on','String','center y');
set(handles.text_param3,'Visible','on', 'String','radius');
set(handles.text_param4,'Visible','on','String','sigma');
set(handles.edit_param1,'Visible','on','String','');
set(handles.edit_param2,'Visible','on','String','');
set(handles.edit_param3,'Visible','on','String','');
set(handles.edit_param4,'Visible','on','String','3');
set(handles.edit_param5,'Visible','off');
set(handles.text_param5,'Visible','off');

handles = getmasks(handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Output function
% -------------------------------------------------------------------------
function varargout = tom_HT_maskeditor_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% -------------------------------------------------------------------------
% Listbox masks
% -------------------------------------------------------------------------
function listbox_masks_Callback(hObject, eventdata, handles)

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Button Load Mask
% -------------------------------------------------------------------------
function button_loadmask_Callback(hObject, eventdata, handles)

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Button Delete Mask
% -------------------------------------------------------------------------
function button_deletemask_Callback(hObject, eventdata, handles)

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Button New Mask
% -------------------------------------------------------------------------
function button_newmask_Callback(hObject, eventdata, handles)

prompt = {'size:'};
dlg_title = 'Create new mask';
num_lines = 1;
def = {'',''};
answer = inputdlg(prompt,dlg_title,num_lines,def);

handles.masksize = str2double(answer{1});
handles.mask = tom_HT_mask(handles.masksize,handles.masksize,handles.projectstruct);
handles.refimage = zeros(handles.masksize,handles.masksize,'single');
handles = render_mask(hObject,handles);

set(handles.edit_param1,'String',num2str(handles.masksize./2+1));
set(handles.edit_param2,'String',num2str(handles.masksize./2+1));
set(handles.edit_param3,'String',num2str(handles.masksize./2));
set(handles.edit_param4,'String','3');

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Listbox References
% -------------------------------------------------------------------------
function listbox_references_Callback(hObject, eventdata, handles)

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Button Load Reference
% -------------------------------------------------------------------------
function button_loadref_Callback(hObject, eventdata, handles)

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Edit box parameter 1
% -------------------------------------------------------------------------
function edit_param1_Callback(hObject, eventdata, handles)

handles = construct_mask(hObject,handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Edit box parameter 2
% -------------------------------------------------------------------------
function edit_param2_Callback(hObject, eventdata, handles)

handles = construct_mask(hObject,handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Edit box parameter 3
% -------------------------------------------------------------------------
function edit_param3_Callback(hObject, eventdata, handles)

handles = construct_mask(hObject,handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Edit box parameter 4
% -------------------------------------------------------------------------
function edit_param4_Callback(hObject, eventdata, handles)

handles = construct_mask(hObject,handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Edit box parameter 4
% -------------------------------------------------------------------------
function edit_param5_Callback(hObject, eventdata, handles)

handles = construct_mask(hObject,handles);

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Button apply
% -------------------------------------------------------------------------
function button_apply_Callback(hObject, eventdata, handles)



guidata(hObject, handles);


% -------------------------------------------------------------------------
% Save & Exit
% -------------------------------------------------------------------------
function button_exit_Callback(hObject, eventdata, handles)

prompt = {'name','description:'};
dlg_title = 'Save mask';
num_lines = 1;
def = {'',''};
answer = inputdlg(prompt,dlg_title,num_lines,def);
handles.mask = set(handles.mask,'name',answer{1});
handles.mask = set(handles.mask,'description',answer{2});
savetodb(handles.mask);


% -------------------------------------------------------------------------
% render mask
% -------------------------------------------------------------------------
function handles = render_mask(hObject,handles)

set(handles.figure_maskeditor,'CurrentAxes',handles.maskaxes);

handles.mask = constructmask(handles.mask);
mask = get(handles.mask,'mask');
handles.maskimage = imagesc(mask');colormap gray;axis off;
 
%set(handles.maskimage,'ButtonDownFcn',{@update_click,hObject});

% -------------------------------------------------------------------------
% update mask view on mouse over
% -------------------------------------------------------------------------
function update_view(src,eventdata,hObject)

handles = guidata(hObject);

p = get(gca,'CurrentPoint');
pt = p(1,1:2);
x = round(pt(1));
y = round(pt(2));

if get(handles.radio_circle,'Value') == 1
    centerx = str2double(get(handles.edit_param1,'String'));    
    centery = str2double(get(handles.edit_param2,'String'));   
    set(handles.edit_param3,'String',num2str(round(sqrt(abs(centerx-x)^2+abs(centery-y)^2))));
    
    
elseif get(handles.radio_rectangle,'Value') == 1
elseif get(handles.radio_poly,'Value') == 1    
elseif get(handles.radio_freehand,'Value') == 1    
elseif get(handles.radio_magicwand,'Value') == 1    
    
end

%handles = construct_mask(hObject,handles);
    
guidata(hObject, handles);
 
    
% -------------------------------------------------------------------------
% update mask on click
% -------------------------------------------------------------------------
function update_click(src,eventdata,hObject)

handles = guidata(hObject);

p = get(gca,'CurrentPoint');
pt = p(1,1:2);
x = round(pt(1));
y = round(pt(2));

%first mouse click
if handles.firstclick == true
    if get(handles.radio_circle,'Value') == 1

        set(handles.edit_param1,'String',num2str(x));
        set(handles.edit_param2,'String',num2str(y));
        if isfield(handles,'centermark')
            try
                delete(handles.centermark);
            end
        end
        handles.centermark = drawmark(x,y);
        handles.firstclick = false;
        set(handles.figure_maskeditor,'WindowButtonMotionFcn',{@update_view,hObject});

    elseif get(handles.radio_rectangle,'Value') == 1
    elseif get(handles.radio_poly,'Value') == 1
    elseif get(handles.radio_freehand,'Value') == 1
    elseif get(handles.radio_magicwand,'Value') == 1

        set(handles.edit_param1,'String',num2str(x));
        set(handles.edit_param2,'String',num2str(y));


   
    end
    
%second mouse click
else

    if get(handles.radio_circle,'Value') == 1
        set(handles.figure_maskeditor,'WindowButtonMotionFcn','');
        handles.firstclick = true;
        handles = construct_mask(hObject,handles);
    elseif get(handles.radio_rectangle,'Value') == 1
    elseif get(handles.radio_poly,'Value') == 1
    elseif get(handles.radio_freehand,'Value') == 1
    elseif get(handles.radio_magicwand,'Value') == 1

    end
    
end

guidata(hObject, handles);


% -------------------------------------------------------------------------
% manages draw tool parameters
% -------------------------------------------------------------------------
function parametermanager(hObject,eventdata)

handles = guidata(hObject);

str = get(eventdata.NewValue,'String');

switch str
    case 'Circle'
        
        set(handles.text_param1,'Visible','on','String','center x');
        set(handles.text_param2,'Visible','on','String','center y');
        set(handles.text_param3,'Visible','on', 'String','radius');
        set(handles.text_param4,'Visible','on','String','sigma');
        set(handles.edit_param1,'Visible','on','String','');
        set(handles.edit_param2,'Visible','on','String','');
        set(handles.edit_param3,'Visible','on','String','');
        set(handles.edit_param4,'Visible','on','String','3');
        set(handles.edit_param5,'Visible','off');
        set(handles.text_param5,'Visible','off');
        set(handles.maskimage,'ButtonDownFcn',{@update_click,hObject});
        
    case 'Rectangle'
        set(handles.text_param1,'Visible','on','String','x');
        set(handles.text_param2,'Visible','on','String','y');
        set(handles.text_param3,'Visible','on', 'String','width');
        set(handles.text_param4,'Visible','on','String','height');
        set(handles.edit_param1,'Visible','on','String','');
        set(handles.edit_param2,'Visible','on','String','');
        set(handles.edit_param3,'Visible','on','String','');
        set(handles.edit_param4,'Visible','on','String','');
        set(handles.edit_param5,'Visible','off');
        set(handles.text_param5,'Visible','off');
        set(handles.maskimage,'ButtonDownFcn','');
        
        waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    
        rbbox;                   
        point2 = get(gca,'CurrentPoint');    
        point1 = point1(1,1:2);              
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             
        offset = abs(point1-point2);         
        x = round([p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)]);
        y = round([p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)]);
        
        set(handles.edit_param1,'String',num2str(x(1)));
        set(handles.edit_param2,'String',num2str(y(1)));        
        set(handles.edit_param3,'String',num2str(abs(x(2)-x(1))));        
        set(handles.edit_param4,'String',num2str(abs(y(3)-y(1))));
        
        handles = construct_mask(hObject,handles);
        
        
    case 'Polygon'
        set(handles.text_param1,'Visible','off','String','');
        set(handles.text_param2,'Visible','off','String','');
        set(handles.text_param3,'Visible','off','String','');
        set(handles.text_param4,'Visible','off','String','');
        set(handles.edit_param1,'Visible','off','String','');
        set(handles.edit_param2,'Visible','off','String','');
        set(handles.edit_param3,'Visible','off','String','');
        set(handles.edit_param4,'Visible','off','String','');
        set(handles.edit_param5,'Visible','off');
        set(handles.text_param5,'Visible','off');
        set(handles.maskimage,'ButtonDownFcn','');
        set(handles.figure_maskeditor,'WindowButtonMotionFcn','');
        set(handles.figure_maskeditor,'CurrentAxes',handles.maskaxes);
        
        bw = roipoly(handles.masksize,handles.masksize);

    case 'Freehand'
    case 'Magic Wand'
        set(handles.text_param1,'Visible','on','String','reference x');
        set(handles.text_param2,'Visible','on','String','reference y');
        set(handles.text_param3,'Visible','on', 'String','tolerance');
        set(handles.text_param4,'Visible','off','String','');
        set(handles.edit_param1,'Visible','on','String','1');
        set(handles.edit_param2,'Visible','on','String','1');
        set(handles.edit_param3,'Visible','on','String','10');
        set(handles.edit_param4,'Visible','off','String','');
        set(handles.edit_param5,'Visible','on','String',{'4','8'});
        set(handles.text_param5,'Visible','on','String','neigbours');
        handles.firstclick = true;
        set(handles.maskimage,'ButtonDownFcn',{@update_click,hObject});
end

guidata(hObject, handles);


% -------------------------------------------------------------------------
% Create functions
% -------------------------------------------------------------------------
function h = drawmark(x,y)

hold on;
Radius = 5;
uu = [x x x x-Radius x+Radius];
vv = [y-Radius y+Radius y y y];
h = line(uu,vv,'LineWidth',1,'color',[1 0 0]);
hold off;


% -------------------------------------------------------------------------
% Construct mask
% -------------------------------------------------------------------------
function handles = construct_mask(hObject,handles)

if get(handles.radio_circle,'Value') == 1

    centerx = str2double(get(handles.edit_param1,'String'));    
    centery = str2double(get(handles.edit_param2,'String'));    
    radius = str2double(get(handles.edit_param3,'String'));    
    sigma = str2double(get(handles.edit_param4,'String'));
    handles.mask = add_maskparams(handles.mask,'circle',centerx,centery,radius,sigma);
    handles = render_mask(hObject,handles);
    handles.centermark = drawmark(centerx,centery);
    
elseif get(handles.radio_rectangle,'Value') == 1
    x = str2double(get(handles.edit_param1,'String'));    
    y = str2double(get(handles.edit_param2,'String'));    
    width = str2double(get(handles.edit_param3,'String'));    
    height = str2double(get(handles.edit_param4,'String'));
    handles.mask = add_maskparams(handles.mask,'rectangle',x,y,width,height);
    handles = render_mask(hObject,handles);
    
elseif get(handles.radio_poly,'Value') == 1    
elseif get(handles.radio_freehand,'Value') == 1    
elseif get(handles.radio_magicwand,'Value') == 1
    x = round(str2double(get(handles.edit_param1,'String')));
    y = round(str2double(get(handles.edit_param3,'String')));
    tol = str2double(get(handles.edit_param3,'String'));
    nei = get(handles.edit_param5,'Value');
    if strcmp(nei,'4')
        nei = 'four';
    else
        nei = 'eigh';
    end
    mask=tom_HT_magicwand(double(handles.refimage), x, y,tol,nei);
    handles.mask = add_maskparams(handles.mask,'magic wand',x,y,tol,nei,mask);

    handles = render_mask(hObject,handles);

end


% -------------------------------------------------------------------------
% get masks from db
% -------------------------------------------------------------------------
function handles = getmasks(handles)

result = tom_HT_getmasks(projectstruct);



% -------------------------------------------------------------------------
% Create functions
% -------------------------------------------------------------------------
function listbox_masks_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_param4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_param3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_param2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_param1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function listbox_references_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_param5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function radio_freehand_Callback(hObject, eventdata, handles)
function radio_poly_Callback(hObject, eventdata, handles)
function radio_rectangle_Callback(hObject, eventdata, handles)
function checkbox_showref_Callback(hObject, eventdata, handles)



