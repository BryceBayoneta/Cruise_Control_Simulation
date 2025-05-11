This is a MATLAB simulation which models the motion of a car whose velocity is automatically controlled by a cruise control system. 
A proportional controller determines the force needed by the engine to reach and maintain target speed
Behavior is modeled using differential equations solved with ode45

Features
- Allows for custom values for:
  - Mass
  - Target Velocity
  - Initial Velocity
  - Drag
  - Control Strength
  - Simulation Time
- Uses Newton's second law to solve vehicle dynamics with drag
- Creates plot of velocity over time
- Determines key values such as rise time (first time to reach target speed), settling time (time to reach and stay at target speed), overshoot (maximum velocity above target), and error (difference between steady state velocity and target)
- Annotates these data on the plot
- Shaded tolerance band included for visual clarity

How To Use
- Run cruiseControl_main.m in MATLAB
- Follow the input prompts

Notes
- May not detect properly with too small of interval
