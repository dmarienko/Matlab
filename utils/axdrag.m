function axdrag(action)
%AXDRAG  Pan and zoom with simple keystrokes
%   Use this tool to move quickly around the data displayed in a 2-D plot.
%   Make sure the figure has focus, and then press any of the following
%   keys to zoom in or out. Clicking and dragging will pan the data.
%
%   Keys you can use are:
%   z, Z: zoom in, zoom out, in both dimensions
%   x, X: zoom in, zoom out, x dimension only
%   y, Y: zoom in, zoom out, y dimension only
%   arrow keys: pan the data
%   a: axis auto
%   n: axis normal
%   e: axis equal
%   g: toggle grid state
%   ?: toggle datatip mode
%   spacebar: toggle axis tick display state
%   h: help
% 
%   Example
%   c = pi*(1+sqrt(5))/2;
%   x = 0:1000;
%   r = 2.72378;
%   z = cumsum(exp(i*(c*x.*x + r)));
%   plot(real(z),imag(z)); 
%   axdrag
%   % Now click, drag, and use special keys ...

%   Copyright 2003, The MathWorks, Inc.
%   Ned Gulley, March 2003

persistent x0 dx 

if nargin < 1,
    action = 'initialize';
end

% Use these variables to change the zoom and pan amounts
zoomFactor = 0.9;
panFactor = 0.02;
panPageFactor = panFactor * 10;

% Get rid of the help window if it's being displayed
helpTextAxis = findobj(gcbf,'Type','axes','Tag','axdraghelpaxis');
if isempty(helpTextAxis)
    helpWasOff = 1;
else
    helpWasOff = 0;
    delete(helpTextAxis);
end

switch action
    
case 'initialize'
    datacursormode off;
    set(gca,'ButtonDownFcn','axdrag start')
    set(gcf,'KeyPressFcn','axdrag keypress')
    set(gcf,'DoubleBuffer','on')
    
case 'start'
    set(gcbf,'Units','pixel');
    set(gca,'Units','pixel');
    set(gcbf,'WindowButtonMotionFcn','axdrag move')
    set(gcbf,'WindowButtonUpFcn','axdrag stop')
    currentPoint = get(gcbf,'CurrentPoint');
    x0 = currentPoint;
    axdrag move
	
case 'move'
    currentPoint = get(gcbf,'CurrentPoint');
    dx = currentPoint - x0;
    x0 = currentPoint;
    ap = get(gca,'Position');
    xLim = get(gca,'XLim');
    yLim = get(gca,'YLim');
    set(gca,'XLim',xLim-(diff(xLim)*dx(1)/ap(3)), ...
       'YLim',yLim-(diff(yLim)*dx(2)/ap(4)));
    
case 'stop'
    set(gcbf,'WindowButtonMotionFcn','')
    set(gcbf,'WindowButtonUpFcn','')
    set(gcbf,'Units','normalized');
    set(gca,'Units','normalized');
    
case 'keypress'
    currChar = get(gcbf,'CurrentCharacter');
    modifiers = get(gcf,'currentModifier');

    if ismember('alt', modifiers), factor = panPageFactor; else factor = panFactor; end

    if isempty(currChar) 
        return
    end
    
    if currChar=='a',
        axis auto
        
    elseif currChar=='e',
        axis equal
        
    elseif currChar=='n',
        axis normal
        
    elseif currChar=='g',
        grid
        
    elseif currChar=='?',
        datacursormode toggle
        % here we need to disable adding protections listeners 
        % see http://groups.google.ca/group/comp.soft-sys.matlab/msg/db42cf51392b442a
        hManager = uigetmodemanager(gcbf);
        set(hManager.WindowListenerHandles,'Enable','off');
        % and here reattach listener again
        set(gcf,'KeyPressFcn','axdrag keypress')
        
    elseif currChar==28,
        xLim=get(gca,'XLim');
        xLimNew = xLim - factor * diff(xLim);
        set(gca,'XLim',xLimNew)
        
    elseif currChar==29,
        xLim=get(gca,'XLim');
        xLimNew = xLim + factor * diff(xLim);
        set(gca,'XLim',xLimNew)
        
    elseif currChar==30,
        yLim=get(gca,'YLim');
        yLimNew = yLim + factor * diff(yLim);
        set(gca,'YLim',yLimNew)
        
    elseif currChar==31,
        yLim=get(gca,'YLim');
        yLimNew = yLim - factor * diff(yLim);
        set(gca,'YLim',yLimNew)
       
    elseif abs(currChar)==32,
      if isempty(get(gca,'XTick')),
         set(gca,'XTickMode','auto','YTickMode','auto')
      else
         set(gca,'XTick',[],'YTick',[],'Box','on')
      end
            
   elseif (currChar=='x') | (currChar=='X'),
      if currChar == 'X',
         zoomFactor=1/zoomFactor;
      end
      xLim=get(gca,'XLim');
      xLimNew = [0 zoomFactor*diff(xLim)] + xLim(1) + (1-zoomFactor)*diff(xLim)/2;
      set(gca,'XLim',xLimNew)
      
   elseif (currChar=='y') | (currChar=='Y'),
      if currChar == 'Y',
         zoomFactor=1/zoomFactor;
      end
      yLim=get(gca,'YLim');
      yLimNew = [0 zoomFactor*diff(yLim)] + yLim(1) + (1-zoomFactor)*diff(yLim)/2;
      set(gca,'YLim',yLimNew)
      
   elseif (currChar=='z') | (currChar=='Z'),
      if currChar == 'Z',
         zoomFactor=1/zoomFactor;
      end
      xLim=get(gca,'XLim');
      yLim=get(gca,'YLim');

 	  xLimNew = [0 zoomFactor*diff(xLim)] + xLim(1) + (1-zoomFactor)*diff(xLim)/2;
      yLimNew = [0 zoomFactor*diff(yLim)] + yLim(1) + (1-zoomFactor)*diff(yLim)/2;

	  set(gca,'XLim',xLimNew,'YLim',yLimNew)
      
    elseif currChar=='h',
        if helpWasOff
            str = { ...
                ' '
                ' AXDRAG. Keys you can use are:'
                ' '
                '  z, Z: zoom in, zoom out, both dimensions '
                '  x, X: zoom in, zoom out, x dimension only '
                '  y, Y: zoom in, zoom out, y dimension only '
                '  arrow keys: pan the data'
                '  a: axis auto'
                '  n: axis normal'
                '  e: axis equal'
                '  g: toggle grid state'
                '  ?: toggle datacursor mode'
                '  spacebar: toggle axis tick display state'
                '  h: help' 
                ' '
                ' Press ''h'' again to dismiss this message' 
                ' ' ...
            };
            helpTextAxis = axes( ...
                'Tag','axdraghelpaxis', ...
                'Units','characters', ...
                'Position',[2 1 76 16], ...
                'Visible','off');
            text(0,1,str, ...
                'Parent',helpTextAxis, ...
                'VerticalAlignment','top', ...
                'BackgroundColor',[1 1 0.8], ...
                'FontName','courier', ...
                'FontSize',6);

        end
        
   end
   
end

   
