% function finds acceleration based on givens
% t - simulation time (used in ODE)
% v - simulation velocity (used in ODE)
%params - vector containing mass, target velocity, control strength, and
%drag coefficient
function acc = cruiseControl(t, v, params)
    m=params(1); % mass
    vt=params(2); % target velocity
    kp=params(3); % control strength
    cd=params(4); % drag coefficient
    diff = vt-v;
    tDrag = cd * vt^2; % drag at target speed
    fEng = tDrag + kp * diff;
    drag = cd * v * abs(v);
    fNet = fEng-drag;
    acc = fNet / m;
end