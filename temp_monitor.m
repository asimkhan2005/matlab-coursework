function temp_monitor(a,pin,g,y,r)
% monitors temperature and controls LEDs

V0 = 0.5;
TC = 0.01;

low = 18;
high = 24;

writeDigitalPin(a,g,0)
writeDigitalPin(a,y,0)
writeDigitalPin(a,r,0)

figure
p = plot(nan,nan);
xlabel('Time (s)')
ylabel('Temperature (^oC)')
title('Live temperature')
grid on

t = [];
temp = [];

t0 = tic;
last = -1;
lastY = 0;
lastR = 0;

ys = 0;
rs = 0;

while ishandle(p)

    nowt = toc(t0);

    if nowt - last >= 1
        last = nowt;

        v = readVoltage(a,pin);
        T = (v - V0)/TC;

        t(end+1,1) = nowt;
        temp(end+1,1) = T;

        set(p,'XData',t,'YData',temp)

        xlim([max(0,nowt-60) nowt+1])

        ymin = min(temp)-1;
        ymax = max(temp)+1;

        if ymin == ymax
            ymin = ymin-1;
            ymax = ymax+1;
        end

        ylim([ymin ymax])
        drawnow

        if T >= low && T <= high

            writeDigitalPin(a,g,1)
            writeDigitalPin(a,y,0)
            writeDigitalPin(a,r,0)

        elseif T < low

            writeDigitalPin(a,g,0)
            writeDigitalPin(a,r,0)

            if nowt - lastY >= 0.5
                lastY = nowt;
                ys = ~ys;
                writeDigitalPin(a,y,ys)
            end

        else

            writeDigitalPin(a,g,0)
            writeDigitalPin(a,y,0)

            if nowt - lastR >= 0.25
                lastR = nowt;
                rs = ~rs;
                writeDigitalPin(a,r,rs)
            end

        end
    end

    pause(0.02)

end

writeDigitalPin(a,g,0)
writeDigitalPin(a,y,0)
writeDigitalPin(a,r,0)

end










