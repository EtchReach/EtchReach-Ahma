#!/usr/bin/env python

import time
import sys
import signal

import VL53L1X

# GPIO initialization
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

# LED config
led = 26
GPIO.setup(led, GPIO.OUT)

print("""distance.py

Display the distance read from the sensor.

Uses the "Short Range" timing budget by default.

Press Ctrl+C to exit.

""")


# Open and start the VL53L1X sensor.
# If you've previously used change-address.py then you
# should use the new i2c address here.
# If you're using a software i2c bus (ie: HyperPixel4) then
# you should `ls /dev/i2c-*` and use the relevant bus number.
tof = VL53L1X.VL53L1X(i2c_bus=1, i2c_address=0x29)
tof.open()

# Optionally set an explicit timing budget
# These values are measurement time in microseconds,
# and inter-measurement time in milliseconds.
# If you uncomment the line below to set a budget you
# should use `tof.start_ranging(0)`
# tof.set_timing(66000, 70)

tof.start_ranging(3)  # Start ranging
                      # 0 = Unchanged
                      # 1 = Short Range
                      # 2 = Medium Range
                      # 3 = Long Range

running = True


def exit_handler(signal, frame):
    global running
    running = False
    tof.stop_ranging()
    print()
    sys.exit(0)


# Attach a signal handler to catch SIGINT (Ctrl+C) and exit gracefully
signal.signal(signal.SIGINT, exit_handler)
read_delay = 1
prev_distance_in_mm = 0
speed_arr = []

while running:
    distance_in_mm = tof.get_distance()
    if not prev_distance_in_mm:
        prev_distance_in_mm = distance_in_mm
    
    speed = (distance_in_mm - prev_distance_in_mm)/read_delay
    speed_arr.append(speed)
    len_speed_arr = len(speed_arr)

    avg_value = 10

    speed_arr = speed_arr[-avg_value:] if len_speed_arr > 10 else speed_arr

    # print("Distance: {}mm".format(distance_in_mm))
    # print(f"Current speed: {speed}mm/s")
    # print(f"Speed Arr: {speed_arr}")

    print(f"Average speed: {sum(speed_arr)/len(speed_arr)}mm/s")

    avg_speed = sum(speed_arr) / len(speed_arr)
    if avg_speed < -30:
        GPIO.output(led, 1)
    else:
        GPIO.output(led, 0)

    prev_distance_in_mm = distance_in_mm

    time.sleep(read_delay)


