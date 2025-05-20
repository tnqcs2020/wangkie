const mongoose = require("mongoose");

const videoSchema = new mongoose.Schema({
  videoId: String,
  title: String,
  thumbnail: String,
  description: String,
  publishedAt: Date,
  cachedAt: { type: Date, default: Date.now, expires: "24h" },
  categoryId: String,
  keywords: [String],
  type: String, // "search" | "category"
  channelId: String,
  channelTitle: String,
  channelAvatar: String,
  viewCount: String,
  likeCount: String,
  commentCount: String,
  duration: String,
  tags: [String],
  isLive: Boolean,
});

module.exports = mongoose.model("Video", videoSchema);
