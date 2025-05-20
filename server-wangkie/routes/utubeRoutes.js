const express = require("express");
const router = express.Router();
const {
  searchVideos,
  getCategoryVideos,
  getTrendingVideos,
} = require("../controllers/utube/utubeController");

const {
  addHistory,
  getHistory,
} = require("../controllers/utube/historyController");

// Tìm kiếm video
router.get("/search", searchVideos);

// Lấy video trending
router.get("/trending", getTrendingVideos);

// Lấy video theo danh mục
router.get("/category/:categoryId", getCategoryVideos);

// Lịch sử xem
router.post("/history", addHistory);
router.get("/history", getHistory);

module.exports = router;
