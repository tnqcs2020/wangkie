const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const User = require("../models/user");
const { sendSuccess, sendError } = require("../utils/response");
const SECRET = process.env.SECRET || "supersecret";

// Đăng ký
const register = async (req, res) => {
  const {
    email,
    password,
    fullName,
    phoneNumber,
    dateOfBirth,
    avatarUrl,
    provider,
    googleId,
    appleId,
  } = req.body;
  try {
    const existing = await User.findOne({ email });
    if (existing) return sendError(res, "Email đã tồn tại", {}, 400);
    const hashedPassword = await bcrypt.hash(password, 10);
    const user = await User.create({
      email,
      password: hashedPassword,
      fullName,
      phoneNumber,
      dateOfBirth,
      avatarUrl,
      provider,
      googleId,
      appleId,
    });
    return sendSuccess(res, "Đăng ký thành công", { user }, 201);
  } catch (err) {
    return sendError(res, "Lỗi máy chủ", err, 500);
  }
};

// Đăng nhập
const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return sendError(res, "Không tìm thấy người dùng", {}, 404);
    const match = await bcrypt.compare(password, user.password);
    if (!match) return sendError(res, "Mật khẩu không đúng", {}, 401);
    const token = jwt.sign({ email }, SECRET, { expiresIn: "7d" });
    return sendSuccess(res, "Đăng nhập thành công", { token, user });
  } catch (err) {
    return sendError(res, "Lỗi máy chủ", err, 500);
  }
};

const loginToken = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return sendError(res, "Không tìm thấy người dùng", {}, 404);
    return sendSuccess(res, "Đăng nhập bằng token thành công", { user });
  } catch (err) {
    return sendError(res, "Lỗi máy chủ", err, 500);
  }
};

// Lấy profile
const getProfile = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return sendError(res, "Không tìm thấy người dùng", {}, 404);
    return sendSuccess(res, "Lấy thông tin thành công", { user });
  } catch (err) {
    return sendError(res, "Token không hợp lệ", err, 401);
  }
};

// Kiểm tra người dùng
const checkUser = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await User.findOne({ email });
    if (!user) return sendError(res, "Không tìm thấy người dùng", {}, 404);
    return sendSuccess(res, "Người dùng tồn tại", { user });
  } catch (err) {
    return sendError(res, "Lỗi máy chủ", err, 500);
  }
};

// Cập nhật profile
const updateProfile = async (req, res) => {
  try {
    const user = await User.findOne({ email: req.user.email });
    if (!user) return sendError(res, "Không tìm thấy người dùng", {}, 404);

    const { fullName, phoneNumber, dateOfBirth, avatarUrl } = req.body;
    if (fullName) user.fullName = fullName;
    if (phoneNumber) user.phoneNumber = phoneNumber;
    if (dateOfBirth) user.dateOfBirth = dateOfBirth;
    if (avatarUrl) user.avatarUrl = avatarUrl;

    await user.save();
    const { password, ...userData } = user.toObject();

    return sendSuccess(res, "Cập nhật thành công", { user: userData });
  } catch (err) {
    return sendError(res, "Token không hợp lệ", err, 401);
  }
};

// Đổi mật khẩu
const changePassword = async (req, res) => {
  const { currentPassword, newPassword } = req.body;

  try {
    const user = await User.findOne({ email: req.user.email });
    if (!user) return sendError(res, "Không tìm thấy người dùng", {}, 404);

    const match = await bcrypt.compare(currentPassword, user.password);
    if (!match) return sendError(res, "Mật khẩu hiện tại không đúng", {}, 400);

    user.password = await bcrypt.hash(newPassword, 10);
    await user.save();

    return sendSuccess(res, "Đổi mật khẩu thành công");
  } catch (err) {
    return sendError(res, "Token không hợp lệ", err, 401);
  }
};

// Xóa tài khoản
const deleteAccount = async (req, res) => {
  try {
    const deleted = await User.findOneAndDelete({ email: req.user.email });
    if (!deleted) return sendError(res, "Không tìm thấy người dùng", {}, 404);

    return sendSuccess(res, "Xóa tài khoản thành công");
  } catch (err) {
    return sendError(res, "Token không hợp lệ", err, 401);
  }
};

module.exports = {
  register,
  login,
  loginToken,
  getProfile,
  checkUser,
  updateProfile,
  changePassword,
  deleteAccount,
};
