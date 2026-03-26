function temp_prediction(a,pin,g,y,r)
% predicts temperature change and controls LEDs

V0 = 0.5;
TC = 0.01;

% This is the voltage at 0 degrees and the temp conversion constant

low = 18;
high = 24;

% Lower safe temp and higher safe temp

limit = 4/60;   

% 4 deg per minute

window = 10;

% Time window used to calculate the rate

writeDigitalPin(a,g,0)
writeDigitalPin(a,y,0)
writeDigitalPin(a,r,0)

% This tturns off all of the LEDs at the start

t = [];
temp = [];

% These store the time and temperature values

t0 = tic;
last = -1;

% This tracks the last reading time

fprintf('\nPrediction running - Ctrl+C to stop\n')

% Displays message i the command window

while true

% This runs forever until stopped 

    nowt = toc(t0);

% This gets the current time

    if nowt - last >= 1
        last = nowt;

        v = readVoltage(a,pin);

% This reads the voltage from the sensor 

        T = (v - V0)/TC;

% Converts voltage to temperature        

        t(end+1,1) = nowt;
        temp(end+1,1) = T;

% These add both time and temperature to an array

        k = find(t <= nowt-window,1,'last');

% This finds the index from tens econds ago        

        if isempty(k)

% This finds that index            

            if length(temp) >= 2
                dT = temp(end) - temp(end-1);

% Change in temp and time

                dt = t(end) - t(end-1);
                rate = dT/dt;

%Rate usijng the last two points
            else
                rate = 0;

% Rate if only one value

            end

        else

% If enough data exists temperature change over window

            dT = temp(end) - temp(k);
            dt = t(end) - t(k);
            
% Time difference

            rate = dT/dt;

% Calculates the rate of change

        end

        pred = T + rate*300;

% Predicts temperatur in 5 mins 

        fprintf('T = %.2f C   rate = %.3f C/s   T in 5 min = %.2f C\n',T,rate,pred)

        gs = 0;
        ys = 0;
        rs = 0;

% LED states all off initially

        if T >= low && T <= high && abs(rate) <= limit

% Temp normal and stable

            gs = 1;

% green on

        elseif rate > limit
            rs = 1;
% Temp rising too fast red light on


        elseif rate < -limit
            ys = 1;

% Temp droppping too fast yellow light on

        end

        writeDigitalPin(a,g,gs)
        writeDigitalPin(a,y,ys)
        writeDigitalPin(a,r,rs)

%updates LEDS


    end

    pause(0.02)

    %small delay
end

end