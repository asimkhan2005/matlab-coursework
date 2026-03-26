% Asim Khan
%egyak21@nottingham.ac.uk


%% PRELIMINARY TASK

clear
clc

a = arduino();
% This would connect me to the arduino board

led = 'D8';

% This is setting the pin of the LED 

writeDigitalPin(a,led,1)
pause(1)
writeDigitalPin(a,led,0)
pause(1)

% This turns the LED on pauses it and makes it wait one second 

for i = 1:10
    writeDigitalPin(a,led,1)
    pause(0.5)
    writeDigitalPin(a,led,0)
    pause(0.5)
end

% This loops the LED flashing ten times but pauses every half a second

%% TASK 1

a = arduino();
% here I am connecting the arduino again

V0 = 0.5;
TC = 0.01;

%Here I am stating the voltage at 0 degrees and I also go on to set the
%temp coefficeint

duration = 600;

% This is the total time in seconds

pin = 'A0';

% Here I am stating my pin input 

location = 'Nottingham';

% This is the measurment location

t = zeros(duration,1);
temp = zeros(duration,1);

% Here I am setting both the time and temperature array

for i = 1:duration

% This is causing the loop for 600 seconds 

    v = readVoltage(a,pin);

% This reads the sensor voltage      
    T = (v - V0)/TC;

% This converts the voltage to temperature    

    t(i) = i-1;

% This is storing the time value 

    temp(i) = T;

% Here I am storing the temperature value 

    pause(1)

% Here I am saying to wait one second     

end

tmax = max(temp);
tmin = min(temp);
tavg = mean(temp);

% This is intiializing the maximum minimum and average temperature 

figure
plot(t,temp)

% This is plotting the temperature against the time 

xlabel('Time (seconds)')
ylabel('Temperature (^oC)')
title('Temperature vs time')
grid on

% This is formatting the graph setting both the x and y axis

saveas(gcf,'temperature_plot.png')

% This is saving the graphical image of the graph we had created 

d = datestr(now,'dd/mm/yyyy');

% This is getting the current date 

fprintf('Data logging initiated - %s\n',d)
fprintf('Location - %s\n\n',location)

% This is displaying the logging information

for m = 0:10

% This is looping for each minute     

    n = m*60 + 1;

% This is findign the index for each minute

    if n > duration
        n = duration;
    end

% This prevents an exceeding array 

    fprintf('Minute\t\t%d\n',m)
    fprintf('Temperature\t%.2f C\n\n',temp(n))

end

% This is displaying the temperature at each minute 

fprintf('Max temp\t%.2f C\n',tmax)
fprintf('Min temp\t%.2f C\n',tmin)
fprintf('Average temp\t%.2f C\n',tavg)
fprintf('Data logging terminated\n')

% This displays the temperature at each minute

fid = fopen('capsule_temperature.txt','w');

% This opens a text file

fprintf(fid,'Data logging initiated - %s\n',d);
fprintf(fid,'Location - %s\n\n',location);

%Writes minute data to file 

for m = 0:10

%Loops through each minute 

    n = m*60 + 1;

% Finds index for each minute    

    if n > duration
        n = duration;
    end

    fprintf(fid,'Minute\t\t%d\n',m);
    fprintf(fid,'Temperature\t%.2f C\n\n',temp(n));

% This writes the minute data to file  

end

fprintf(fid,'Max temp\t%.2f C\n',tmax);
fprintf(fid,'Min temp\t%.2f C\n',tmin);
fprintf(fid,'Average temp\t%.2f C\n',tavg);
fprintf(fid,'Data logging terminated\n');

% Writes final results to file

fclose(fid);

%This closes the file

type capsule_temperature.txt

% This displays my files contents

%% TASK 2

Ain = 'A0';

% This sets the analogue input for the sensor 

g = 'D6';

% This sets the green LED pin

y = 'D5';

% Here I am setting the yellow LED pin

r = 'D7';

% Here I am setting the red LED pin

temp_monitor(a,Ain,g,y,r)

% This is telling the function to monitor the temperature and control the
% LEDs

%% TASK 3

Ain = 'A0';
g = 'D6';
y = 'D5';
r = 'D7';

% This sets the pins as stated above

temp_prediction(a,Ain,g,y,r)

% This calls the function to predict the temperature and control the LEDs