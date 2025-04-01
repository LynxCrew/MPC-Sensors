# LynxCrew MPC-Sensors Plugin

## What does it do:
This plugin enables you to register the virtual MPC temperature sensors of Kalico
to make them visible in your frontend of choice

## Install:
SSH into you pi and run:
```
cd ~
wget -O - https://raw.githubusercontent.com/LynxCrew/MPC-Sensors/main/scripts/install.sh | bash
```

then add this to your moonraker.conf:
```
[update_manager mpc-sensors]
type: git_repo
channel: dev
path: ~/mpc-sensors
origin: https://github.com/LynxCrew/MPC-Sensors.git
managed_services: klipper
primary_branch: main
install_script: scripts/install.sh
```

also add
```
[mpc_block_temperature]

[mpc_ambient_temperature]
```
to your printer config to actually load the modules (this has to be before registering the sensors, otherwise it wont work due to how klipper reads configs)

## Config reference:
```
[temperature_sensor Block_Temperature]
sensor_type: mpc_block_temperature
heater_name: extruder
#   Put the name of the heater this sensor is tied to (this parameter is required)
#gcode_id: BE
min_temp: 0
max_temp: 325

[temperature_sensor Ambient_Temperature]
sensor_type: mpc_ambient_temperature
heater_name: extruder
#   Put the name of the heater this sensor is tied to (this parameter is required)
#gcode_id: AT
min_temp: 0
max_temp: 325
