clc, clear
screenWidth = 1920;
screenHeight = 1080;
mask = zeros(screenHeight, screenWidth);                                                   % Create a 1920x1080 array
plotArray = zeros(864, 1536);
get(0, "MonitorPositions")                                                  % Determine screen coordinates (main + projector)
serialportlist("available")
arduinoObj = serialport("COM7",9600);                                      % ComPort and baud rate for arduino serial connection
configureTerminator(arduinoObj,"CR/LF");                                   % Set terminator to /r/n
flush(arduinoObj);       
calibPlot = zeros(1, 255);

% Adjust image corner to corner of projector screen
%-------------------------------------------------------------------

hFig1 = figure('Name','Calibration Mask',...
    'Numbertitle','off',...
    'Position', [1921 265 screenWidth screenHeight],...
    'WindowStyle','modal',...
    'Color',[0 0 0],...
    'Toolbar','none');
fpos = get(hFig1,'Position');
axOffset = (fpos(3:4)-[size(mask,2) size(mask,1)])/2;
ha = axes('Parent',hFig1,'Units','pixels',...
                'Position',[axOffset size(mask,2) size(mask,1)]);
%---------------------------------------------------------------------

hFig2 = figure('Name','Calibration Plot',...
    'Numbertitle','off',...
    'Position', [1 1 1536 864],...
    'WindowStyle','modal',...
    'Color',[0 0 0],...
    'Toolbar','none');
fpos2 = get(hFig2,'Position');
axOffset2 = (fpos2(3:4)-[size(plotArray,1) size(plotArray,1)])/2;
ha2 = axes('Parent',hFig2,'Units','pixels',...
                'Position',[axOffset size(plotArray,2) size(plotArray,1)]);



% This block will loop through they grayscale values
%-------------------------------------------------------------------------
for grayVal=1:255

    % This block will loop through the image array
    %---------------------------------------------------------------------
    for x=1:screenWidth
        for y=1:screenHeight
            mask(y,x)=grayVal;                                              % Set each element in array to grayscale value (looped from 1 to 255)
        end
    end
    %---------------------------------------------------------------------

    imshow(uint8(mask),'Parent',ha);                                      % Project image for each grayscale value
    grayVal                                                                % Print current grayscale value
    pause(0.25);                                                            % Time constant in seconds for LDR
    
    
    dataArray = zeros(1,50);                                               % Create the array that will contain the arduino readings
    for dataIndex=1:50
        dataArray(dataIndex) = str2double(readline(arduinoObj));
        pause(0.02)
        %dataArray(dataIndex) = rand;
    end
    calibPlot(grayVal) = mean(dataArray);
    plot(calibPlot)
end

