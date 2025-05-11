clearvars
clc

% improvements to be made
    % if it settles in last 10%, not caught
        % maybe find a way to create interval for user
    % logic could probably be made cleaner
    % graphs could look nicer
    % fprintfs at end can be combined

%% receive inputs
fprintf('This is a script to simulate a cruise control system in a car\n\n')
mass = input('What is the mass of the car (kg)?\n->');
speedT = input('What is the target speed (m/s)?\n->');
speedI = input('How fast is the car at first (m/s)\n->');
dragCoeff = input('What is the drag coefficient of the car?\n->');
controlStrength = input('What is the control strength (proportional gain)?\n->');
tf = input('How long should the simulation run (s)?\n->');
time = [0,tf];
params = [mass, speedT, controlStrength, dragCoeff];

[t, v] = ode45(@(t, v) cruiseControl(t, v, params), time, speedI);

%% time to reach target speed
i=1;
j=1;
check = false;
riseTime=0;
windowLength = t(end) * .1; % window is 10% of simulation time

while ~check
    if j > length(t) % ends loop if end of interval
        break
    end
    if t(j) - t(i) < windowLength % creates interval by increasing j until valid
        j=j+1;
    elseif abs(v(i) - speedT) > speedT * .05 % moves interval one index if difference too large
        i=i+1;
    else % only enters else if v(i) within tolerance
        if riseTime==0 
            riseTime=t(i);
        end
        for k=i:j % checks every index
            if abs(v(k)-speedT) > speedT * .02 % if one value outside range, break loop
                check=false;
                i=i+1;
                break;
            end
        end
        check=true;
    end
end
if check==true
    settlingTime = t(i);

    error = v(end)-speedT;

    fprintf('The car first reaches the target speed at %f seconds\n', riseTime)
    fprintf('The car reaches and stays at the target speed at %f seconds\n', settlingTime)
    fprintf('The final velocity is %f m/s from the desired speed', error)
    if speedI < speedT % overshoot only prints if initial is below target and overshoot is present
        [max, index] = max(v);
        if max > speedT
            overshoot = (max-speedT)*100/speedT;
            tOvershoot = t(index);
            fprintf('The car has an overshoot of %f%% above the target speed\nIt reaches the max overshoot at %f\n', overshoot, tOvershoot)
        end
    end
else
    fprintf('The car never settles. please try a larger interval\nIf this doesn''t work, kp may be too low for these conditions')
end

%% plot speed over time

figure
plot(t,v, '-b')
hold on
yline(speedT, '--k', 'Target Speed');
%create bar to show tolerance range
y1=speedT-speedT*.05;
y2=speedT+speedT*.05;
x1=t(1);
x2=t(end);
xRec=[x1 x2 x2 x1];
yRec=[y1 y1 y2 y2];
fill(xRec, yRec, [.8 .8 .8], 'EdgeColor', 'none', 'FaceAlpha',.3)

if riseTime >0
    xline(riseTime, ':r');
    text(riseTime -.5, speedT*.2, 'Rise Time', 'Color', 'Red', 'Rotation', 90, 'HorizontalAlignment', 'left')
end
if exist('settlingTime', 'var')
    xline(settlingTime, ':k');
    text(settlingTime +.5, speedT*.2, 'Settling Time', 'Color', [.5 0 .5], 'Rotation', 90, 'HorizontalAlignment', 'left')
end
if exist('tOvershoot', 'var')
    xline(tOvershoot, ':y', 'Overshoot Time');
end
hold off