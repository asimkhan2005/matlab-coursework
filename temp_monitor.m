function temp_monitor(a,pin,g,y,r)
% monitors temperature and controls LEDs

V0 = 0.5;

% This is the voltage at 0 degrees

TC = 0.01;

% This is setting the temperature coefficeint 

low = 18;
high = 24;

% This is setting both the lower and upper limit of our code 

writeDigitalPin(a,g,0)
writeDigitalPin(a,y,0)
writeDigitalPin(a,r,0)

% This turns all of the LEDs off at the start

figure
p = plot(nan,nan);

% This is creating the empty plot for our graph

xlabel('Time (s)')
ylabel('Temperature (^oC)')
title('Live temperature')
grid on

% This is doing the formatting for our graph setting the temperature as the
% y axis and time as the x 

t = [];

% This is the time array

temp = [];

% This is the temperature array

t0 = tic;

% This starts the timer

last = -1;

% This is the last time a reading was taken

lastY = 0;

% This is the last time yellow changed 

lastR = 0;

% This is the last time the red LED changed

ys = 0;
rs = 0;

% This is showing the red and yellow LED state

while ishandle(p)

% Runs while figure is open

    nowt = toc(t0);

% Current time    

    if nowt - last >= 1
        last = nowt;

% This shows it rus every one second

        v = readVoltage(a,pin);
        T = (v - V0)/TC;

% This reads the voltage and then converts to temperature        

        t(end+1,1) = nowt;
        temp(end+1,1) = T;

% This converts to temperature and then stores time

        set(p,'XData',t,'YData',temp)

% This updates the plot

        xlim([max(0,nowt-60) nowt+1])

% This shows the last 60 seconds        

        ymin = min(temp)-1;
        ymax = max(temp)+1;

%This sets the y limits      

        if ymin == ymax
            ymin = ymin-1;
            ymax = ymax+1;
        end

%This prevents the graph from being flat        
         

        ylim([ymin ymax])
        drawnow

% This updates the graph

        if T >= low && T <= high

%This is indicating normal temperature            

            writeDigitalPin(a,g,1)
            writeDigitalPin(a,y,0)
            writeDigitalPin(a,r,0)

% This enables the green LED to come on            

        elseif T < low

            writeDigitalPin(a,g,0)
            writeDigitalPin(a,r,0)

% This means the temperature is too low         

            if nowt - lastY >= 0.5
                lastY = nowt;
                ys = ~ys;
                writeDigitalPin(a,y,ys)
            end

% Here the yellow LED flasshes             

        else

% else the temperature is too high

            writeDigitalPin(a,g,0)
            writeDigitalPin(a,y,0)

            if nowt - lastR >= 0.25
                lastR = nowt;
                rs = ~rs;
                writeDigitalPin(a,r,rs)
            end

        end
    end

% Here the red LED flashes 

    pause(0.02)

% here the pauses can delay

end

writeDigitalPin(a,g,0)
writeDigitalPin(a,y,0)
writeDigitalPin(a,r,0)

end

% Here the LEDs tuhrn off at the end








