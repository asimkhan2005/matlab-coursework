% Asim Khan
%egyak21@nottingham.ac.uk


%% PRELIMINARY TASK

clear
clc

a = arduino();

led = 'D8';

writeDigitalPin(a,led,1)
pause(1)
writeDigitalPin(a,led,0)
pause(1)

for i = 1:10
    writeDigitalPin(a,led,1)
    pause(0.5)
    writeDigitalPin(a,led,0)
    pause(0.5)
end


%% TASK 1

a = arduino();

V0 = 0.5;
TC = 0.01;

duration = 600;
pin = 'A0';
location = 'Nottingham';

t = zeros(duration,1);
temp = zeros(duration,1);

for i = 1:duration

    v = readVoltage(a,pin);
    T = (v - V0)/TC;

    t(i) = i-1;
    temp(i) = T;

    pause(1)

end

tmax = max(temp);
tmin = min(temp);
tavg = mean(temp);

figure
plot(t,temp)
xlabel('Time (seconds)')
ylabel('Temperature (^oC)')
title('Temperature vs time')
grid on

saveas(gcf,'temperature_plot.png')

d = datestr(now,'dd/mm/yyyy');

fprintf('Data logging initiated - %s\n',d)
fprintf('Location - %s\n\n',location)

for m = 0:10

    n = m*60 + 1;

    if n > duration
        n = duration;
    end

    fprintf('Minute\t\t%d\n',m)
    fprintf('Temperature\t%.2f C\n\n',temp(n))

end

fprintf('Max temp\t%.2f C\n',tmax)
fprintf('Min temp\t%.2f C\n',tmin)
fprintf('Average temp\t%.2f C\n',tavg)
fprintf('Data logging terminated\n')

fid = fopen('capsule_temperature.txt','w');

fprintf(fid,'Data logging initiated - %s\n',d);
fprintf(fid,'Location - %s\n\n',location);

for m = 0:10

    n = m*60 + 1;

    if n > duration
        n = duration;
    end

    fprintf(fid,'Minute\t\t%d\n',m);
    fprintf(fid,'Temperature\t%.2f C\n\n',temp(n));

end

fprintf(fid,'Max temp\t%.2f C\n',tmax);
fprintf(fid,'Min temp\t%.2f C\n',tmin);
fprintf(fid,'Average temp\t%.2f C\n',tavg);
fprintf(fid,'Data logging terminated\n');

fclose(fid);

type capsule_temperature.txt


%% TASK 2

Ain = 'A0';
g = 'D6';
y = 'D5';
r = 'D7';

temp_monitor(a,Ain,g,y,r)


%% TASK 3

Ain = 'A0';
g = 'D6';
y = 'D5';
r = 'D7';

temp_prediction(a,Ain,g,y,r)