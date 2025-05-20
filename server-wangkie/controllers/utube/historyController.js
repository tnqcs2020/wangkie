const History = require("../../models/utube/history");

exports.addHistory = async (req, res) => {
  const { email, videoId, title, thumbnail } = req.body;
  const history = new History({ email, videoId, title, thumbnail });
  await history.save();
  res.json({ success: true });
};

exports.getHistory = async (req, res) => {
  const { email } = req.query;
  const history = await History.find({ email }).sort({ watchedAt: -1 });
  res.json(history);
};
