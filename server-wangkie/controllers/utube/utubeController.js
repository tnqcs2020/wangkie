const axios = require("axios");
const Video = require("../../models/utube/video");
const { getApiKey } = require("../../utils/apiKeyManager");
const stringSimilarity = require("string-similarity");

const YOUTUBE_API_BASE = "https://www.googleapis.com/youtube/v3";
// Tìm kiếm video

// Hàm gọi API YouTube search
async function fetchSearchVideos(query, maxResults = 50) {
  const API_KEY = await getApiKey();
  const url = `${YOUTUBE_API_BASE}/search?part=snippet&type=video&q=${encodeURIComponent(
    query
  )}&maxResults=${maxResults}&key=${API_KEY}`;
  const res = await axios.get(url);
  return res.data.items;
}

// Hàm lấy chi tiết video
async function fetchVideoDetails(videoIds) {
  const API_KEY = await getApiKey();
  const url = `${YOUTUBE_API_BASE}/videos?part=snippet,contentDetails,statistics,liveStreamingDetails&id=${videoIds}&key=${API_KEY}`;
  const res = await axios.get(url);
  return res.data.items;
}

const normalizeKeyword = (text) => {
  const stopWords = ["in", "on", "at", "the", "a", "of", "to", "for", "and"];
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // remove accents
    .split(/\s+/)
    .filter((word) => !stopWords.includes(word))
    .sort()
    .join(" ");
};

const CACHE_HOURS = 24;

exports.searchVideos = async (req, res) => {
  const { q, maxResults = 50 } = req.query;
  const normalizedQ = normalizeKeyword(q || "");
  const cutoff = new Date(Date.now() - CACHE_HOURS * 60 * 60 * 1000);

  try {
    // Lấy tất cả từ khóa đã lưu
    const cachedKeywords = await Video.distinct("keywords", {
      type: "search",
      cachedAt: { $gt: cutoff },
    });

    // Chỉ chọn từ khóa cache có ít nhất 1 từ giống với từ khóa mới
    const queryWords = normalizedQ.split(" ");

    const filteredCandidates = cachedKeywords.filter((kw) => {
      return queryWords.some((w) => kw.includes(w));
    });

    // Rồi mới dùng stringSimilarity
    const similarityScores = filteredCandidates.map((cached) => ({
      keyword: cached,
      score: stringSimilarity.compareTwoStrings(normalizedQ, cached),
    }));

    // Chỉ giữ từ khóa có điểm >= 0.7
    const relevant = similarityScores
      .filter((s) => s.score >= 0.7)
      .sort((a, b) => b.score - a.score);

    if (relevant.length > 0) {
      const relatedKeywords = relevant.map((s) => s.keyword);

      const keywordPriority = new Map();
      relevant.forEach((r, i) => keywordPriority.set(r.keyword, i));

      const cachedVideos = await Video.find({
        keywords: { $in: relatedKeywords },
        type: "search",
        cachedAt: { $gt: cutoff },
      });

      // Sắp xếp video theo độ ưu tiên keyword
      cachedVideos.sort((a, b) => {
        const aPriority = Math.min(
          ...(a.keywords || []).map((k) => keywordPriority.get(k) ?? Infinity)
        );
        const bPriority = Math.min(
          ...(b.keywords || []).map((k) => keywordPriority.get(k) ?? Infinity)
        );
        return aPriority - bPriority;
      });

      if (cachedVideos.length) {
        const BONUS_SCORE = 0.3;

        const titleScores = cachedVideos.map((video) => {
          const normalizedQuery = normalizeKeyword(q);
          const normalizedKeywords = normalizeKeyword(
            video.keywords?.join(" ") || ""
          );
          const normalizedTitle = video.title.toLowerCase();

          const scoreKeyword = stringSimilarity.compareTwoStrings(
            normalizedQuery,
            normalizedKeywords
          );
          const scoreTitle = stringSimilarity.compareTwoStrings(
            normalizedTitle,
            q.toLowerCase()
          );

          let score = 0.6 * scoreKeyword + 0.4 * scoreTitle;

          // Bonus nếu query là substring của keyword hoặc title
          if (normalizedKeywords.includes(normalizedQuery)) {
            score += BONUS_SCORE;
          }
          if (normalizedTitle.includes(q.toLowerCase())) {
            score += BONUS_SCORE;
          }

          // Đảm bảo điểm không vượt quá 1
          if (score > 1) score = 1;

          return { video, score };
        });

        // Sắp xếp theo tổng điểm giảm dần
        titleScores.sort((a, b) => b.score - a.score);

        const sortedVideos = titleScores.map((v) => v.video);

        console.log("✅ Trả cache liên quan :", relatedKeywords);
        return res.json(sortedVideos.slice(0, maxResults));
      }
    }

    // Nếu không đủ liên quan, gọi API
    const searchResults = await fetchSearchVideos(normalizedQ, maxResults);
    if (!searchResults.length) return res.json([]);

    const videoIds = searchResults.map((item) => item.id.videoId).join(",");
    const videosDetails = await fetchVideoDetails(videoIds);

    const BONUS_SCORE = 0.3;

    const normalizedQuery = normalizeKeyword(q || "");

    const scoredVideos = videosDetails.map((video) => {
      const snippet = video.snippet;
      const normalizedTitle = normalizeKeyword(snippet.title || "");

      let score = stringSimilarity.compareTwoStrings(
        normalizedTitle,
        normalizedQuery
      );

      // Ưu tiên nếu query là substring trong title gốc
      if (
        (snippet.title || "").toLowerCase().includes((q || "").toLowerCase())
      ) {
        score += BONUS_SCORE;
      }

      if (score > 1) score = 1;

      return {
        score,
        data: {
          videoId: video.id,
          title: snippet.title,
          description: snippet.description,
          thumbnail: snippet.thumbnails?.standard?.url || "",
          publishedAt: snippet.publishedAt,
          cachedAt: new Date(),
          categoryId: snippet.categoryId || "",
          keywords: normalizedQuery,
          type: "search",
          channelId: snippet.channelId,
          channelTitle: snippet.channelTitle,
          channelAvatar: snippet.thumbnails?.default?.url || "",
          viewCount: video.statistics?.viewCount || "0",
          likeCount: video.statistics?.likeCount || "0",
          commentCount: video.statistics?.commentCount || "0",
          duration: video.contentDetails?.duration || "",
          tags: snippet.tags || [],
          isLive: !!video.liveStreamingDetails?.actualStartTime,
        },
      };
    });

    // 🔽 Sắp xếp theo score giảm dần
    scoredVideos.sort((a, b) => b.score - a.score);

    const videosToCache = scoredVideos.map((v) => v.data);

    const bulkOps = videosToCache.map((video) => ({
      updateOne: {
        filter: { videoId: video.videoId },
        update: {
          $set: {
            title: video.title,
            description: video.description,
            thumbnail: video.thumbnail,
            publishedAt: video.publishedAt,
            cachedAt: video.cachedAt,
            categoryId: video.categoryId,
            type: video.type,
            channelId: video.channelId,
            channelTitle: video.channelTitle,
            channelAvatar: video.channelAvatar,
            viewCount: video.viewCount,
            likeCount: video.likeCount,
            commentCount: video.commentCount,
            duration: video.duration,
            tags: video.tags,
            isLive: video.isLive,
          },
          $addToSet: { keywords: normalizedQ },
        },
        upsert: true,
      },
    }));
    await Video.bulkWrite(bulkOps, { ordered: false });
    console.log("📡 Gọi YouTube API cho từ khóa:", normalizedQ);

    res.json(videosToCache);
  } catch (err) {
    console.error("❌ Error in searchVideos:", err.message);
    res.status(500).json({ message: "Failed to fetch videos" });
  }
};

// Lấy video trending
// const TRENDING_CACHE_MINUTES = 10;

async function fetchTrendingVideos(regionCode = "VN", maxResults = 50) {
  const API_KEY = await getApiKey();
  const url =
    `${YOUTUBE_API_BASE}/videos?` +
    `part=snippet,contentDetails,statistics&` +
    `chart=mostPopular&regionCode=${regionCode}&maxResults=${maxResults}&key=${API_KEY}`;
  const res = await axios.get(url);
  return res.data.items;
}

exports.getTrendingVideos = async (req, res) => {
  const { regionCode = "VN", maxResults = 50 } = req.query;
  const cutoff = new Date(Date.now() - CACHE_HOURS * 60 * 60 * 1000);

  try {
    // Check cache first
    const cached = await Video.find({
      type: "trending",
      cachedAt: { $gt: cutoff },
    }).limit(maxResults);

    if (cached.length > 0) {
      console.log(`✅ Trả cache trending (${regionCode})`);
      return res.json(cached);
    }

    // Fetch from API
    const trendingVideos = await fetchTrendingVideos(regionCode, maxResults);

    // B1: Lấy danh sách channelId duy nhất
    const channelIds = [
      ...new Set(trendingVideos.map((v) => v.snippet.channelId)),
    ];

    // B2: Gọi YouTube API để lấy avatar từng channel
    const API_KEY = await getApiKey();
    const channelInfoUrl = `${YOUTUBE_API_BASE}/channels?part=snippet&id=${channelIds.join(
      ","
    )}&key=${API_KEY}`;
    const channelsRes = await axios.get(channelInfoUrl);

    // Tạo map: channelId → avatarUrl
    const channelAvatarMap = new Map();
    channelsRes.data.items.forEach((channel) => {
      channelAvatarMap.set(
        channel.id,
        channel.snippet.thumbnails?.default?.url || ""
      );
    });

    const videos = trendingVideos.map((video) => {
      const snippet = video.snippet;
      const statistics = video.statistics || {};
      const contentDetails = video.contentDetails || {};

      return {
        videoId: video.id,
        title: snippet.title,
        description: snippet.description,
        thumbnail: snippet.thumbnails?.standard?.url || "",
        publishedAt: snippet.publishedAt,
        cachedAt: new Date(),
        categoryId: snippet.categoryId || "",
        type: "trending",
        regionCode: regionCode.toUpperCase(),
        channelId: snippet.channelId,
        channelTitle: snippet.channelTitle,
        channelAvatar: channelAvatarMap.get(snippet.channelId) || "",
        viewCount: statistics.viewCount || "0",
        likeCount: statistics.likeCount || "0",
        commentCount: statistics.commentCount || "0",
        duration: contentDetails.duration || "",
        tags: snippet.tags || [],
        isLive: false,
      };
    });

    // Cache
    const bulkOps = videos.map((video) => ({
      updateOne: {
        filter: { videoId: video.videoId },
        update: { $set: video },
        upsert: true,
      },
    }));

    await Video.bulkWrite(bulkOps, { ordered: false });

    console.log(`🔥 Lấy trending mới từ API (${regionCode})`);
    res.json(videos);
  } catch (err) {
    console.error("❌ Error in getTrendingVideos:", err.message);
    res.status(500).json({ message: "Failed to fetch trending videos" });
  }
};

// Lấy video theo category
exports.getCategoryVideos = async (req, res) => {
  const { categoryId } = req.params;
  const maxResults = 50;
  const API_KEY = await getApiKey();

  try {
    // Gọi API lấy video theo categoryId
    const url = `${YOUTUBE_API_BASE}/search?part=snippet&type=video&videoCategoryId=${categoryId}&maxResults=${maxResults}&order=date&key=${API_KEY}`;
    const resSearch = await axios.get(url);
    const searchResults = resSearch.data.items;

    if (!searchResults.length) return res.json([]);

    const videoIds = searchResults.map((item) => item.id.videoId).join(",");

    // Lấy chi tiết video
    const videosDetails = await fetchVideoDetails(videoIds);

    // Map dữ liệu theo schema và thêm categoryId, type = "category"
    const videosToCache = videosDetails.map((video) => {
      const snippet = video.snippet;
      const statistics = video.statistics || {};
      const contentDetails = video.contentDetails || {};
      const liveDetails = video.liveStreamingDetails || {};

      return {
        videoId: video.id,
        title: snippet.title,
        thumbnail: snippet.thumbnails?.standard?.url || "",
        description: snippet.description,
        publishedAt: snippet.publishedAt,
        cachedAt: new Date(),
        categoryId: categoryId,
        keyword: "",
        type: "category",
        channelId: snippet.channelId,
        channelTitle: snippet.channelTitle,
        channelAvatar: snippet.thumbnails?.default?.url || "",
        viewCount: statistics.viewCount || "0",
        likeCount: statistics.likeCount || "0",
        commentCount: statistics.commentCount || "0",
        duration: contentDetails.duration || "",
        tags: snippet.tags || [],
        isLive: !!liveDetails.actualStartTime,
      };
    });

    // Lưu vào MongoDB, bỏ qua lỗi trùng
    await Video.insertMany(videosToCache, { ordered: false }).catch(() => {});

    res.json(videosToCache);
  } catch (err) {
    console.error("Error in getCategoryVideos:", err.message);
    res.status(500).json({ message: "Failed to fetch category videos" });
  }
};
