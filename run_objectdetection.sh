#!/bin/bash

source env/bin/activate
cd examples/lite/examples/object_detection/raspberry_pi
python3 detect_led_bbox.py \
  --model efficientdet_lite0.tflite
