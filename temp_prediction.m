function temp_prediction(a,pin,g,y,r)
% predicts temperature change and controls LEDs

V0 = 0.5;
TC = 0.01;

low = 18;
high = 24;

limit = 4/60;   % 4 deg per minute
window = 10;

writeDigitalPin(a,g,0)
writeDigitalPin(a,y,0)
writeDigitalPin(a,r,0)

t = [];
temp = [];

t0 = tic;
last = -1;

fprintf('\nPrediction running - Ctrl+C to stop\n')

while true

    nowt = toc(t0);

    if nowt - last >= 1
        last = nowt;

        v = readVoltage(a,pin);
        T = (v - V0)/TC;

        t(end+1,1) = nowt;
        temp(end+1,1) = T;

        k = find(t <= nowt-window,1,'last');

        if isempty(k)

            if length(temp) >= 2
                dT = temp(end) - temp(end-1);
                dt = t(end) - t(end-1);
                rate = dT/dt;
            else
                rate = 0;
            end

        else

            dT = temp(end) - temp(k);
            dt = t(end) - t(k);
            rate = dT/dt;

        end

        pred = T + rate*300;

        fprintf('T = %.2f C   rate = %.3f C/s   T in 5 min = %.2f C\n',T,rate,pred)

        gs = 0;
        ys = 0;
        rs = 0;

        if T >= low && T <= high && abs(rate) <= limit
            gs = 1;
        elseif rate > limit
            rs = 1;
        elseif rate < -limit
            ys = 1;
        end

        writeDigitalPin(a,g,gs)
        writeDigitalPin(a,y,ys)
        writeDigitalPin(a,r,rs)

    end

    pause(0.02)

end

end