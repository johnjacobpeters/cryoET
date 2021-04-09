function [backgroundColor, API, windowClipPanelWidth] = ...
    createWindowClipPanel(hFlow, imgModel)
%createWindowClipPanel Create windowClipPanel in imcontrast tool
%   outputs =
%   createWindowClipPanel(hFig,imageRange,imgHasLessThan5Levels,imgModel)
%   creates the WindowClipPanel (top panel in contrast tool) in the contrast
%   tool. Outputs are used to set up display and callbacks in imcontrast.
%
%   This function is used by IMCONTRAST.

%   Copyright 2005-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2007/01/15 14:37:54 $

% Global scope
[getEditBoxValue, formatEditBoxString] = getFormatFcns(imgModel);

% Create panel.
hWindowClipPanel = uipanel('parent', hFlow, ...
    'Units', 'pixels', ....
    'BorderType', 'none', ...
    'Tag', 'window clip panel');

backgroundColor = get(hWindowClipPanel,'BackgroundColor');

hWindowClipPanelMargin = 5;
hWindowClipPanelFlow = uiflowcontainer('Parent', hWindowClipPanel,...
    'FlowDirection', 'LeftToRight', ...
    'Margin', hWindowClipPanelMargin);

fudge = 30;

imDataRangePanelWH = createImDataRangePanel;

[editBoxAPI, eyedropperAPI, windowPanelWH] = ...
    createWindowPanel;

[scalePanelAPI, scaleDisplayPanelWH] = createScaleDisplayPanel;

API.editBoxAPI = editBoxAPI;
API.scalePanelAPI = scalePanelAPI;
API.eyedropperAPI = eyedropperAPI;

windowClipPanelWidth = imDataRangePanelWH(1) + windowPanelWH(1) + ...
    scaleDisplayPanelWH(1) + fudge;
windowClipPanelHeight = max([imDataRangePanelWH(2) windowPanelWH(2) ...
    scaleDisplayPanelWH(2)]) + fudge;

set(hWindowClipPanel, ...
    'HeightLimits', [windowClipPanelHeight windowClipPanelHeight], ...
    'WidthLimits', [windowClipPanelWidth windowClipPanelWidth]);


    %==============================================================
    function imDataRangePanelWH = createImDataRangePanel

        hImDataRangePanel = uipanel('Parent', hWindowClipPanelFlow,...
            'Tag', 'data range panel',...
            'Title', 'Data Range');

        horWeight = [1 1];
        hImIntGridMgr = uigridcontainer('Parent', hImDataRangePanel,...
            'HorizontalWeight', horWeight,...
            'GridSize', [2 2]);
        hImMin = uicontrol('Parent', hImIntGridMgr,...
            'Style', 'Text',...
            'HorizontalAlignment', 'left',...
            'Tag','min data range label',...
            'String', 'Minimum:');
        hImMinEdit = uicontrol('Parent',hImIntGridMgr,...
            'Style', 'Edit',...
            'Tag', 'min data range edit',...
            'TooltipString', 'The image''s minimum intensity value', ...
            'HorizontalAlignment', 'right',...
            'String', formatEditBoxString(getMinIntensity(imgModel)),...
            'Enable', 'off');
        hImMax = uicontrol('Parent', hImIntGridMgr,...
            'Style', 'Text',...
            'Tag','max data range label',...
            'HorizontalAlignment', 'left',...
            'String', 'Maximum:');
        hImMaxEdit = uicontrol('Parent',hImIntGridMgr,...
            'Style', 'Edit',...
            'Tag', 'max data range edit',...
            'TooltipString', 'The image''s maximum intensity value', ...
            'HorizontalAlignment', 'right',...
            'String', formatEditBoxString(getMaxIntensity(imgModel)),...
            'Enable', 'off');
        
        imDataRangePanelWH = calculateWHOfPanel;
        set(hImDataRangePanel,'WidthLimits', ...
                          [imDataRangePanelWH(1) imDataRangePanelWH(1)], ...
                          'HeightLimits', ...
                          [imDataRangePanelWH(2) imDataRangePanelWH(2)]);
        
                
        %======================================
        function panelWH = calculateWHOfPanel

            % Calculate width and height limits of the panel.
            [topRowWidth topRowHeight] = ...
                getTotalWHofControls([hImMin hImMinEdit]);
            [botRowWidth botRowHeight] = ...
                getTotalWHofControls([hImMax hImMaxEdit]);

            maxWidth = max([topRowWidth botRowWidth]) + 2 * fudge;
            maxHeight = topRowHeight + botRowHeight + fudge;
            panelWH = [maxWidth maxHeight];
        end

    end

    %======================================================================
    function [editBoxAPI, eyedropperAPI, windowPanelWH] = ...
            createWindowPanel

        hWindowPanel = uipanel('Parent', hWindowClipPanelFlow,...
            'Tag', 'window panel',...
            'BackgroundColor', backgroundColor,...
            'Title', 'Window');

        hWindowPanelFlow = uiflowcontainer('Parent', hWindowPanel,...
            'FlowDirection', 'LeftToRight',...
            'Margin', 0.1);

        % Create min/max edit boxes and eyedroppers.
        windowPanelHorWeight1 = [1.2 1 0.5];
        hWinPanelGridMgr1 = uigridcontainer('Parent', hWindowPanelFlow,...
            'GridSize', [2 3],...
            'HorizontalWeight', windowPanelHorWeight1);
        hMinLabel = uicontrol('parent', hWinPanelGridMgr1, ...
            'style', 'text', ...
            'Tag','window min label',...
            'string', 'Minimum:', ...
            'HorizontalAlignment', 'left', ...
            'BackgroundColor', backgroundColor);
        hMinEdit = uicontrol('parent', hWinPanelGridMgr1, ...
            'Style', 'Edit', ...
            'Tag', 'window min edit', ...
            'HorizontalAlignment', 'right', ...
            'BackgroundColor', [1 1 1], ...
            'TooltipString', 'The window''s minimum intensity value');
        iconRoot = ipticondir;
        iconCdata = makeToolbarIconFromPNG(fullfile(iconRoot, ...
            'tool_eyedropper_black.png'));
        hMinDropper = uicontrol('parent', hWinPanelGridMgr1, ...
            'style', 'pushbutton', ...
            'cdata', iconCdata, ...
            'TooltipString', 'Select minimum window value from image', ...
            'tag', 'min eye dropper button', ...
            'HorizontalAlignment', 'center');
        hMaxLabel = uicontrol('parent', hWinPanelGridMgr1, ...
            'style', 'text', ...
            'Tag','window max label',...
            'string', 'Maximum:', ...
            'HorizontalAlignment', 'left', ...
            'BackgroundColor', backgroundColor);
        hMaxEdit = uicontrol('parent', hWinPanelGridMgr1, ...
            'Style', 'Edit', ...
            'Tag', 'window max edit', ...
            'HorizontalAlignment', 'right', ...
            'BackgroundColor', [1 1 1], ...
            'TooltipString', 'The window''s maximum intensity value');
        iconCdata = makeToolbarIconFromPNG(fullfile(iconRoot, ...
            'tool_eyedropper_white.png'));
        hMaxDropper = uicontrol('parent', hWinPanelGridMgr1, ...
            'style', 'pushbutton', ...
            'cdata', iconCdata, ...
            'TooltipString', 'Select maximum window value from image', ...
            'tag', 'max eye dropper button', ...
            'HorizontalAlignment', 'center');

        % Create window/center edit boxes.
        windowPanelHorWeight2 = [0.1 0.6 1];
        hWinPanelGridMgr2 = uigridcontainer('Parent', hWindowPanelFlow,...
            'GridSize', [2 3],...
            'Margin', 0.1,...
            'HorizontalWeight', windowPanelHorWeight2);
        spacing1 = uicontrol('Parent', hWinPanelGridMgr2, ...
            'Tag','spacing',...
            'Style','Text');
        hWidthLabel = uicontrol('parent', hWinPanelGridMgr2, ...
            'style', 'text', ...
            'Tag','window width label',...
            'string', 'Width:', ...
            'HorizontalAlignment', 'left', ...
            'BackgroundColor', backgroundColor);
        hWidthEdit = uicontrol('parent', hWinPanelGridMgr2, ...
            'Style', 'Edit', ...
            'Tag', 'window width edit', ...
            'HorizontalAlignment', 'right', ...
            'BackgroundColor', [1 1 1], ...
            'TooltipString', 'The width of the intensity window');
        spacing2 = uicontrol('Parent', hWinPanelGridMgr2,...
            'Style', 'Text',...
            'tag', 'spacing');
        hCenterLabel = uicontrol('parent', hWinPanelGridMgr2, ...
            'style', 'text', ...
            'tag','window center label',...
            'string', 'Center:', ...
            'HorizontalAlignment', 'left', ...
            'BackgroundColor', backgroundColor);
        hCenterEdit = uicontrol('parent', hWinPanelGridMgr2, ...
            'Style', 'Edit', ...
            'Tag', 'window center edit', ...
            'HorizontalAlignment', 'right', ...
            'BackgroundColor', [1 1 1], ...
            'TooltipString', 'The center of the intensity window');

        windowPanelWH = calculateWHOfPanel;
        set(hWindowPanel,...
            'HeightLimits', [windowPanelWH(2) windowPanelWH(2)],...
            'WidthLimits', [windowPanelWH(1) windowPanelWH(1)]);
        
        %============================================
        function windowPanelWH = calculateWHOfPanel
       
            topRow = [hMinLabel hMinEdit hMinDropper spacing1 hWidthLabel ...
                      hWidthEdit]; 
            [topRowWidth topRowHeight] = ...
                getTotalWHofControls(topRow);
            
            botRow = [hMaxLabel hMaxEdit hMaxDropper hCenterLabel ...
                      spacing2 hCenterEdit]; 
            [botRowWidth botRowHeight] = ...
                getTotalWHofControls(botRow);
            
            panelWidth = max([topRowWidth botRowWidth]) + 7 * fudge;
            panelHeight = sum([topRowHeight botRowHeight]) + fudge;
            windowPanelWH = [panelWidth panelHeight];
        end

        [editBoxAPI, eyedropperAPI] = createWindowWidgetAPI;
        
        %==========================================================
        function [editBoxAPI, eyedropperAPI] = createWindowWidgetAPI

            editBoxAPI.centerEdit.handle = hCenterEdit;
            editBoxAPI.centerEdit.set    = @setCenter;
            editBoxAPI.centerEdit.get    = @() getEditValue(hCenterEdit);

            editBoxAPI.maxEdit.handle = hMaxEdit;
            editBoxAPI.maxEdit.set    = @setMaxValue;
            editBoxAPI.maxEdit.get    = @() getEditValue(hMaxEdit);

            editBoxAPI.minEdit.handle = hMinEdit;
            editBoxAPI.minEdit.set    = @setMinValue;
            editBoxAPI.minEdit.get    = @() getEditValue(hMinEdit);

            editBoxAPI.widthEdit.handle  = hWidthEdit;
            editBoxAPI.widthEdit.set     = @setWidthEdit;
            editBoxAPI.widthEdit.get     = @() getEditValue(hWidthEdit);

            eyedropperAPI.minDropper.handle = hMinDropper;
            eyedropperAPI.minDropper.set    = '';
            eyedropperAPI.minDropper.get    = 'minimum';

            eyedropperAPI.maxDropper.handle = hMaxDropper;
            eyedropperAPI.maxDropper.set    = '';
            eyedropperAPI.maxDropper.get    = 'maximum';

            %=========================
            function setMinValue(clim)
                set(hMinEdit, 'String', formatEditBoxString(clim(1)));
            end

            %=========================
            function setMaxValue(clim)
                set(hMaxEdit, 'String', formatEditBoxString(clim(2)));
            end

            %=======================
            function setWidthEdit(clim)
                width = computeWindow(clim);
                set(hWidthEdit, 'String', formatEditBoxString(width));
            end

            %=======================
            function setCenter(clim)
                [tmp center] = computeWindow(clim);
                set(hCenterEdit,'String', formatEditBoxString(center));
            end
        end %createWindowWidgetAPI

        %=============================================
        function [width, center] = computeWindow(CLim)
            width = CLim(2) - CLim(1);
            center = CLim(1) + width ./ 2;
        end

    end %createWindowPanel

    %======================================================================
    function [scalePanelAPI,scaleDisplayPanelWH] = ...
            createScaleDisplayPanel

        enablePropValue = 'on';
        defaultOutlierValue = '2';

        hScaleDisplayPanel = uibuttongroup('Parent', hWindowClipPanelFlow,...
            'Tag', 'scale display range panel', ...
            'BackgroundColor', backgroundColor, ...
            'Title', 'Scale Display Range');
        hScaleDisplayFlow = uiflowcontainer('Parent', hScaleDisplayPanel,...
            'FlowDirection', 'TopDown');

        hMatchDataRangeBtn = uicontrol('Parent', hScaleDisplayFlow,...
            'Style', 'Radiobutton', ...
            'Enable', enablePropValue, ...
            'Tag', 'match data range radio',...
            'String', 'Match Data Range');

        elimGridHorWeight = [1,0.25,0.1];
        hElimGridMgr = uigridcontainer('Parent', hScaleDisplayFlow,...
            'HorizontalWeight', elimGridHorWeight, ...
            'Margin', 0.1, ...
            'GridSize', [1,3]);
        hElimRadioBtn = uicontrol('Parent', hElimGridMgr,...
            'Style', 'RadioButton', ...
            'Enable', enablePropValue, ...
            'Tag', 'eliminate outliers radio',...
            'String', 'Eliminate outliers:');
        hPercentEdit = uicontrol('Parent', hElimGridMgr,...
            'Style', 'Edit', ...
            'Enable', enablePropValue, ...
            'Background', 'w', ...
            'Tag', 'outlier percent edit',...
            'String', defaultOutlierValue);
        hPercentText = uicontrol('Parent', hElimGridMgr,...
            'Style', 'Text', ...
            'Enable', enablePropValue, ...
            'Tag','% string',...
            'String', '%');

        buttonFlow = uiflowcontainer('Parent', hScaleDisplayFlow,...
            'Margin', 0.1, ...
            'FlowDirection', 'LeftToRight');
        hScaleDisplayBtn = uicontrol('Parent', buttonFlow,...
            'Style', 'Pushbutton',...
            'Tag', 'apply button',...
            'Tooltip', 'Scale the image''s display range',...
            'Enable', enablePropValue,...
            'String','Apply');
        set(hScaleDisplayBtn, 'WidthLimits',[60 75]);

        scaleDisplayPanelWH = calculateWHOfPanel;

        set(hScaleDisplayPanel,...
            'HeightLimits', ...
            [scaleDisplayPanelHeight scaleDisplayPanelHeight],...
            'WidthLimits', ...
            [scaleDisplayPanelWidth scaleDisplayPanelWidth]);

        %==================================
        function pWH = calculateWHOfPanel

            [topRowWidth topRowHeight] = ...
                getTotalWHofControls(hMatchDataRangeBtn);

            midRow = [hElimRadioBtn hPercentEdit hPercentText];
            [midRowWidth midRowHeight] = ...
                getTotalWHofControls(midRow);
            
            [botRowWidth botRowHeight] = ...
                getTotalWHofControls(hScaleDisplayBtn);

            scaleDisplayPanelWidth = midRowWidth + 2 * fudge;
            scaleDisplayPanelHeight = topRowHeight + midRowHeight + ...
                botRowHeight + fudge;
            pWH = [scaleDisplayPanelWidth scaleDisplayPanelHeight];
       end

        scalePanelAPI = createScalePanelAPI;

        %=========================================
        function scalePanelAPI = createScalePanelAPI

            scalePanelAPI.elimRadioBtn.handle = hElimRadioBtn;
            scalePanelAPI.elimRadioBtn.set = ...
                @(v) set(hElimRadioBtn, 'Value', v);
            scalePanelAPI.elimRadioBtn.get = ...
                @() get(hElimRadioBtn, 'Value');

            scalePanelAPI.matchDataRangeBtn.handle = hMatchDataRangeBtn;
            scalePanelAPI.matchDataRangeBtn.set = ...
                @(v) set(hMatchDataRangeBtn, 'Value', v);
            scalePanelAPI.matchDataRangeBtn.get = ...
                @() get(hMatchDataRangeBtn, 'Value');

            scalePanelAPI.percentEdit.handle = hPercentEdit;
            scalePanelAPI.percentEdit.set = ...
                @(s) set(hPercentEdit, 'String', s);
            scalePanelAPI.percentEdit.get = ...
                @() getEditValue(hPercentEdit);

            scalePanelAPI.scaleDisplayBtn.handle = hScaleDisplayBtn;
            scalePanelAPI.scaleDisplayBtn.set = '';
            scalePanelAPI.scaleDisplayBtn.get = '';
        end

    end %createScaleDisplayPanel

    %===============================
    function value = getEditValue(h)
        value = getEditBoxValue(sscanf(get(h, 'string'), '%f'));
    end
                
    %==================================================================
    function [totalWidth totalHeight] = getTotalWHofControls(hControls)
        extents = get(hControls, 'Extent');
        if iscell(extents)
            extents = [extents{:}];
        end
        totalWidth = sum(extents(3:4:end));
        totalHeight = max(extents(4:4:end));
    end
end % createWindowClipPanel

%==========================================================================
function [getEditBoxValue, formatEditBoxString] = getFormatFcns(imgModel)

[tmp, imgContainsFloat, imgNeedsExponent] = getNumberFormatFcn(imgModel);

isIntegerData = ~strcmp(getClassType(imgModel),'double');

if isIntegerData
    getEditBoxValue = @round;
    formatEditBoxString = @(val) sprintf('%0.0f', val);

else
    getEditBoxValue = @(x) x;
    if imgNeedsExponent
        formatEditBoxString = @createStringForExponents;
    elseif imgContainsFloat
        formatEditBoxString = @(val) sprintf('%0.4f', val);
    else
        % this case handles double data that contains integers, e.g., eye(100), int16
        % data, etc.q
        formatEditBoxString = @(val) sprintf('%0.0f', val);
    end
end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function string = createStringForExponents(value)
  
        string = sprintf('%1.1E', value);
        string = fixENotation(string);
    end
end