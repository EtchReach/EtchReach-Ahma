import RPi.GPIO as GPIO
import time
# GPIO.setmode(GPIO.BCM)
# GPIO.setwarnings(False)

# # Pin config

def output(pin, type):
    if type == "buzz":
        GPIO.output(pin,1)
        print("Buzzing")
        time.sleep(1)
        GPIO.output(pin,0)
    elif type == "tap":
        print("Tapping")
        servo1 = GPIO.PWM(pin, 50) # Note 11 is pin, 50 = 50Hz pulse
        # #start PWM running, but with value of 0 (pulse off)
        servo1.start(0)
        time.sleep(1)
        # # Turn back to 90 degrees
        servo1.ChangeDutyCycle(7)
        time.sleep(0.3)
        # #turn back to 0 degrees
        servo1.ChangeDutyCycle(2)
        time.sleep(0.5)
        servo1.ChangeDutyCycle(0)
        #Clean things up at the end
        servo1.stop()