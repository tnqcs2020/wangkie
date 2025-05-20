const axios = require("axios");

const keys = [
  process.env.YOUTUBE_API_KEY_1,
  process.env.YOUTUBE_API_KEY_2,
  process.env.YOUTUBE_API_KEY_3,
  process.env.YOUTUBE_API_KEY_4,
];

let index = 0;

// Gọi API nhẹ để test key
async function isKeyValid(key) {
  try {
    const url = `https://www.googleapis.com/youtube/v3/videos?part=snippet&id=Ks-_Mh1QhMc&key=${key}`;
    const res = await axios.get(url);

    return res.status === 200 && res.data?.items?.length > 0;
  } catch (err) {
    const code = err?.response?.status;
    const message = err?.response?.data?.error?.message;
    console.warn(
      `❌ Key failed (${key.slice(0, 10)}...): ${code} - ${message}`
    );
    return false;
  }
}

// Lấy key còn quota
async function getApiKey() {
  const tried = new Set();

  while (tried.size < keys.length) {
    const key = keys[index];
    index = (index + 1) % keys.length;

    if (await isKeyValid(key)) {
      console.log("✅ Using key:", key.slice(0, 10) + "...");
      return key;
    }

    tried.add(key);
    console.warn("❌ Key failed (quota or invalid):", key.slice(0, 10) + "...");
  }

  throw new Error("🚫 No available YouTube API keys with quota.");
}

module.exports = { getApiKey };
