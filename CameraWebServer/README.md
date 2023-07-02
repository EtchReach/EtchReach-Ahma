# Camera Web Server

This folder contains the code for the ESP32-CAM server. It returns a live image feed at the `IP:81/stream` endpoint using the MJPEG protocol. It also returns a single image at the `IP/capture` endpoint.

## Setup

1. Install `Arduino` from the [Arduino website](https://www.arduino.cc/en/software).
2. Install `ESP32` boards from the `Boards Manager`, by following the instructions [here](https://randomnerdtutorials.com/installing-the-esp32-board-in-arduino-ide-windows-instructions/)
3. Select the `AI Thinker ESP32-CAM` board from the `Tools > Board` menu.
4. Open the `CameraWebServer.ino` file.
5. Upload the code to the ESP32-CAM using an FTDI programmer, by following the instructions [here](https://randomnerdtutorials.com/program-upload-code-esp32-cam/).
