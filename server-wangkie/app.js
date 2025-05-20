require("dotenv").config();
const express = require("express");
const cors = require("cors");
const connectDB = require("./config/db");
const userRoutes = require("./routes/userRoutes");
const utubeRoutes = require("./routes/utubeRoutes");

const app = express();
connectDB();

app.use(cors());
app.use(express.json({ limit: "10mb" }));

app.get("/", (req, res) => {
  res.send("Welcome to Wangkie!");
});

app.use("/api", userRoutes);
app.use("/api/utube", utubeRoutes);

module.exports = app;
