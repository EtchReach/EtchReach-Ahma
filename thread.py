import logging
# import threading
from multiprocessing import Pool
import time
from examples.lite.examples.object_detection.raspberry_pi.detect_led_bbox import main

#!/usr/bin/env python

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

tof = VL53L1X.VL53L1X(i2c_bus=1, i2c_address=0x29)
tof.open()

def exit_handler(signal, frame):
  global running
  running = False
  tof.stop_ranging()
  print()
  sys.exit(0)

def TOF():
  tof.start_ranging(3)  # Start ranging
                      # 0 = Unchanged
                      # 1 = Short Range
                      # 2 = Medium Range
                      # 3 = Long Range

  running = True

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

      avg_value = 5

      speed_arr = speed_arr[-avg_value:] if len_speed_arr > 10 else speed_arr

      # print("Distance: {}mm".format(distance_in_mm))
      # print(f"Current speed: {speed}mm/s")
      # print(f"Speed Arr: {speed_arr}")

      print(f"Average speed: {sum(speed_arr)/len(speed_arr)}mm/s")

      avg_speed = sum(speed_arr) / len(speed_arr)
      if avg_speed < -30:
          GPIO.output(led, 1)
          print("Buzzing!")
      else:
          GPIO.output(led, 0)

      prev_distance_in_mm = distance_in_mm

      time.sleep(read_delay)


def thread_function(name):
    logging.info("Thread %s: starting", name)
    time.sleep(2)
    logging.info("Thread %s: finishing", name)

if __name__ == "__main__":
    # format = "%(asctime)s: %(message)s"
    # logging.basicConfig(format=format, level=logging.INFO,
    #                     datefmt="%H:%M:%S")

    # logging.info("Main    : before creating thread")
    # x = threading.Thread(target=TOF)
    # logging.info("Main    : before running thread")
    # x.start()
    # logging.info("Main    : wait for the thread to finish")
    # # x.join()
    # logging.info("Main    : all done")

    pool = Pool(processes=2)
    r1 = pool.apply_async(TOF)
    r2 = pool.apply_async(main)
    
    pool.close()
    pool.join()
