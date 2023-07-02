# Express Camera Web Server

This folder contains the code for an `express` server that mocks the ESP32 camera API. It returns an image from the `images` folder when the `/capture` endpoint is called.

## Setup

1. Install `node` and `npm` from [here](https://nodejs.org/en/download/)
2. Install dependencies: `npm install`
3. Run the server: `npm start`
4. The server should begin at `localhost:3000`
5. To test whether the server is working, go to `localhost:3000/capture` in your browser. You should see an image.

## Endpoints

### `/capture`

Returns an image from the `images` folder.
