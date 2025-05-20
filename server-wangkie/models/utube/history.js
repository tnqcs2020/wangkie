const mongoose = require('mongoose');

const historySchema = new mongoose.Schema({
  email: String,
  videoId: String,
  title: String,
  thumbnail: String,
  watchedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('History', historySchema);