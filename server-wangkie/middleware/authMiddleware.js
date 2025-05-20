const jwt = require("jsonwebtoken");
const { sendError } = require("../utils/response");

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader) return sendError(res, "Thiếu token trong header", {}, 401);

  const token = authHeader.split(" ")[1];
  if (!token) return sendError(res, "Token không hợp lệ", {}, 401);

  try {
    const decoded = jwt.verify(token, process.env.SECRET || "supersecret");
    req.user = decoded;
    next();
  } catch (err) {
    if (err.name === "TokenExpiredError") {
      return sendError(res, "Token đã hết hạn", err, 401);
    }
    return sendError(res, "Token không hợp lệ", err, 401);
  }
};

module.exports = authMiddleware;
