%% Information
%Author : Ezequiel G. Debada.
%Data   : 2015-07-21

%% Initialization
close all;clear all;clc;
addpath('./Functions');

%% Create serial object for Arduino
baudrate = 115200;
%baudrate = 1200;
s = serial('COM3','BaudRate',baudrate); % change the COM Port number as needed
s.ReadAsyncMode = 'manual';
set(s,'InputBufferSize',100);

%% Connect the serial port to Arduino
try
    fopen(s);
catch err
    fclose(instrfind);
    error('Make sure you select the correct COM Port where the Arduino is connected.');
end

%% Prepare Figures
Fig = figure('Position',[9 9 913 1014],'ToolBar','none');
Ax(1) = axes('Position',[0.04 .81 0.92 .18]);grid;hold on;
for k = 1:3
    H(k) = plot(0,0);
end
Ax(2) = axes('Position',[.15 0.03 .7 .7],'CameraPosition',[-9.1314 -11.9003 8.6603]);hold on;
axis([-1 1 -1 1 -1 1]);
%% Read and plot the data from Arduino
Tmax = 60;Ts = 0.02; i = 1;ata = 0;t = 0;
tic % Start timer
T(i)=0;
FLAG_CASTING = false;
CubH = [];Angles=zeros(1,3);
Flag_Initializing = true;

while(Flag_Initializing)
    while(strcmp(s.TransferStatus,'read'))
        pause(0.01);
    end    
    readasync(s);
    sms = fscanf(s);
    if ~strcmp(sms(1:3),'ypr')
        fprintf(sms)
    else
        Flag_Initializing = false;
    end
end
while T(end) <= 2000
% while T(end) <= 100
    T(end+1)=T(end)+1;
    sms='a';
    idx = [];
    Angles = [0];
    while isempty(idx) || numel(Angles)~=3
        sms = fscanf(s);
        idx = find(sms=='r');
        if ~isempty(idx)
            idx = idx(end)+1;
            Angles = sscanf(sms(idx:end),'%f %f %f');
        end
    end    
    Yaw = Angles(3);
    Pitch = Angles(2);
    Roll = Angles(1);
    
    k = 1;        
    vY = get(H(k),'YData');vX = get(H(k),'XData');
    set(H(k),'YData',[vY,Angles(k)]);set(H(k),'XData',[vX,T(end)]); 

    k = 2;
    vY = get(H(k),'YData');vX = get(H(k),'XData');
    set(H(k),'YData',[vY,Angles(k)]);set(H(k),'XData',[vX,T(end)]); 

    k = 3;
    vY = get(H(k),'YData');vX = get(H(k),'XData');
    set(H(k),'YData',[vY,Angles(k)]);set(H(k),'XData',[vX,T(end)]); 
    
    CubH = Plot_Cube(deg2rad(-Yaw),deg2rad(Pitch),deg2rad(Roll),Ax(2),CubH);
    drawnow;
end
fclose(s);

