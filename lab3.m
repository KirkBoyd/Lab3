clc;
clear;
close all;

%CONSTANTS
T_infinity = 20; %degrees Celsius
convCriteria = 0.0001; %later add input command here
guess = 7; %later add input command here
k = 1; %later add input command
deltaX = 1*10^-3;
h_0 = 1;%W/(K*m^2)

%MATRIX SETUP
T_old = zeros(14);
flag = true;
tripped = false;

%VARIABLES
count = 0;
sum = 0; %variable for storing the sum of values in the 4 nodes around 
         %node to be evaluated
         
for i=1:length(T_old) %%adds guess value for nodes to be populated
    T_old(i,:) = guess; 
end %%for loop
for i=1:length(T_old) %add left wall boundary values
    T_old(i,1) = 300+10*(13-i);%%add left wall values where T(0,y)=(300+10y)
end %%for loop
%% LEFT WALL (Y = 0)
for i=7:length(T_old)%add T_infinity values
    T_old(1,i) = T_infinity;
    T_old(2,i) = T_infinity;
    T_old(3,i) = T_infinity;
    T_old(7,i) = T_infinity;
    T_old(8,i) = T_infinity;
    T_old(12,i) = T_infinity;
    T_old(13,i) = T_infinity;
    T_old(14,i) = T_infinity;
end %for i=7

T_new = T_old; %create second array to store new values

while flag
    %populate node values
    h = h_0*(1+(x-5)/(8));

%     T_old = T_new;  %at the beginning of loop, copy new values to T_old
%                     %before changing the values in T_new again
    for i=2:length(T_new)-1 %start for loop for x indices
        for j=2:length(T_new)-1 %start for loop for y indices
            %% BIG LEFT PIECE
            if 1<j && j<6
                if i==1 || i==14
                    T_new(i,j) = (0.5*T_old(i-1,j)+0.5*T_old(i+1,j)+T_old(i,j-1))/3;
                end %if i == 1
                %% INTERNAL NODES
                if 1<i && i<14
                    T_new(i,j) = (T_old(i-1,j)+T_old(i,j-1)+T_old(i+1,j)+T_old(i,j+1))/4;
                end %if 1<i...
            end %if i<j...
            if j==6
                %if i==1
                if (1<i && i<4) || (6<i && i<9) || (11<i && i<14)
                    T_new(i,j) = (k*(T_old(i-1,j)+0.5*T_old(i,j-1)+0.5*T_old(i,j+1) + ((h*deltaX)/k)*T_infinity))/(2*k + h*deltaX);
                end %if i<1
            end %if j ==6
            %sum = T_old(i-1,j)+T_old(i,j-1)+T_old(i+1,j)+T_old(i,j+1);
            T_new(i,j) = sum/4; %change T_new value at index to newest value
            
            if abs(T_new(i,j)-T_old(i,j))>convCriteria
                tripped = true; %if any value is above conv criteria, this 
                                %becomes true and flag will stay up
            end %if abs(...
        end %for j
    end %for i
%         
%    count = count +1;
%    if tripped
%        flag = true;
%    else
%        flag = false;
%    end %if/else
%    tripped = false; %reset tripped for next iteration
end %while flag