%% Information
%Author : Ezequiel G. Debada.
%Data   : 2015-07-21

%% Initializing
close all;clear all;clc;

%% Parameters
%Number of points in each spin.
points = 30;

%Plot
Fig = figure;
Ax = axes('CameraPosition',[-9.1314 -11.9003 8.6603]);
axis([-1 1 -1 1 -1 1]);hold on;

%Yaw
CubH=[];
for dim = 1:3
    for ang = 0:2*pi/points:2*pi
       Ori = zeros(1,3); 
       Ori(dim)=ang;
%        cla(Ax);       
       CubH = Plot_Cube(Ori(1),Ori(2),Ori(3),Ax,CubH);
       drawnow;
       pause(0.05);
    end
end
