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
    T_old(1,i) = 0;
    T_old(2,i) = 0;
    T_old(3,i) = 0;
    T_old(7,i) = 0;
    T_old(8,i) = 0;
    T_old(12,i) = 0;
    T_old(13,i) = 0;
    T_old(14,i) = 0;
end %for i=7

T_new = T_old; %create second array to store new values

while flag
    %populate node values
    

    T_old = T_new;  %at the beginning of loop, copy new values to T_old
                    %before changing the values in T_new again
    for i=1:length(T_new) %start for loop for y indices
        for j=1:length(T_new) %start for loop for x indices
            h = h_0*(1+(j-5)/(8));
            %X=2 to x=5
            if 1<j && j<6 %if x is between 1 and 6...
                if i==1 % if it is a top node
                    T_new(i,j) = (1/3)*(0.5*T_old(i,j-1) + 0.5*T_old(i,j+1) + T_old(i+1,j)); %eq. A
                end
                if i==14 % if it is a bottom node
                    T_new(i,j) = (1/3)*(0.5*T_old(i,j-1) + 0.5*T_old(i,j+1) + T_old(i-1,j)); %eq. B
                end
                if 1<i && i<14 %if it is a central node
                    T_new(i,j) = (1/4)*(T_old(i,j-1) + T_old(i+1,j) + T_old(i,j-1) + T_old(i-1,j));%eq. C
                end       
            end
            if j==6 %if x = 6...
                if (1<i && i<4) || (6<i && i<9) || (11<i && i<14) %if vertical convection node
                    T_new(i,j) = (k/(2*k+h*deltaX))*(T_old(i,j-1) + 0.5*T_old(i+1,j) + 0.5*T_old(i-1,j) + ((h*deltaX)/k)*T_infinity); %eq D
                end
                if i==4 || i==9 %if top left fin corner
                    T_new(i,j) = (1/(3+(h/k)))*(0.5*T_old(i-1,j) + T_old(i,j-1) + T_old(i+1,j) + 0.5*T_old(i,j+1) + (h/k)*T_infinity); %eq. I
                end
                if i==5 || i==10 %if fin base internal node
                    T_new(i,j) = (1/4)*(T_old(i,j-1) + T_old(i+1,j) + T_old(i,j-1) + T_old(i-1,j));%eq. C
                end
                if i==6 || i==11 %if botom left fin corner
                    T_new(i,j) = (1/(3+(h/k)))*(T_old(i-1,j) + T_old(i,j-1) + 0.5*T_old(i+1,j) + 0.5*T_old(i,j+1) + (h/k)*T_infinity);%eq. J
                end
                if i==1 %if top corner node (y=1)
                    T_new(i,j) = (1/(2*k+h))*(k*T_old(i,j-1) + k*T_old(i+1,j) + h*T_infinity);%eq. G
                end
                if i==14 %if bottom corner node (y=14)
                    T_new(i,j) = (1/(2*k+h))*(k*T_old(i,j-1) + k*T_old(i-1,j) + h*T_infinity);%eq. H
                end
            end
            if 6<j && j<14 %if x is between 6 and 14
                if i==4 || i==9 %if top fin surface node
                    T_new(i,j) = (1/(2*k+h))*((k/2)*T_old(i,j-1) + k*T_old(i+1,j) + (k/2)*T_old(i,j+1) + h*T_infinity);%eq. E
                end %if i==4...
                if i==5 || i==10 %if fin internal node
                    T_new(i,j) = (1/4)*(T_old(i,j-1) + T_old(i+1,j) + T_old(i,j-1) + T_old(i-1,j));%eq. C
                end %if i==5
                if i==6 || i==11 %if bottom fin surface node
                    T_new(i,j) = (1/(2*k+h))*((k/2)*T_old(i,j-1) + k*T_old(i-1,j) + (k/2)*T_old(i,j+1) + h*T_infinity); %eq. F
                end %if i==6
            end %if 6<j...
            if j==14 %if it is a far right node
                if i==4 || i==9 %if fin top right corner
                    T_new(i,j) = (1/(1+(h/k)))*(0.5*T_old(i,j-1) + 0.5*T_old(i+1,j) + (h/k)*T_infinity); %eq. K
                end %if i==4...
                if i==5 || i==10 %if fin right vertical
                    T_new(i,j) = (k/(2*k+h*deltaX))*(T_old(i,j-1) + 0.5*T_old(i+1,j) + 0.5*T_old(i-1,j) + ((h*deltaX)/k)*T_infinity); %eq D
                end %if i==5
                if i==6 || i==11 %if fin bottom right corner
                    T_new(i,j) = (1/(1+(h/k)))*(0.5*T_old(i,j-1) + 0.5*T_old(i-1,j) + (h/k)*T_infinity); %eq. L
                end %if i==6
            end %if j==14
            
            %Check conv
            if abs(T_new(i,j)-T_old(i,j))>convCriteria
                tripped = true; %if any value is above conv criteria, this 
                                %becomes true and flag will stay up
            end %if abs(...
        end %for j
    end %for i
        
   count = count +1;
   if tripped
       flag = true;
   else
       flag = false;
   end %if/else
   tripped = false; %reset tripped for next iteration
end %while flag