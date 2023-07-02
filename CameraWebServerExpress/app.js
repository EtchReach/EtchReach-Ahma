const express = require("express");
const app = express();

// Endpoint to send the image as the API response
app.get("/capture", (req, res) => {
  const imagePath = "/assets/images/bike_person.png";

  // Send the image file as the response
  res.sendFile(__dirname + imagePath);
});

// Start the server
app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
