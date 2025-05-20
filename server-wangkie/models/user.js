const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true, default: "" },
  fullName: { type: String, required: true },
  phoneNumber: { type: String, default: "" },
  dateOfBirth: { type: String, default: "" },
  avatarUrl: { type: String, default: "" },
  provider: {
    type: String,
    enum: ["local", "google", "apple"],
    default: "local",
  },
  googleId: { type: String, default: "" },
  appleId: { type: String, default: "" },
});

const User = mongoose.model("User", userSchema);

module.exports = User;
