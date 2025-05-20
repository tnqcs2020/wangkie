const express = require("express");
const {
  register,
  login,
  loginToken,
  checkUser,
  getProfile,
  updateProfile,
  changePassword,
  deleteAccount,
} = require("../controllers/userController");
const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/auth/register", register);
router.post("/auth/login", login);
router.post("/auth/login-token", authMiddleware, loginToken);
router.post("/user/isExistUser", checkUser);
router.post("/user/profile", authMiddleware, getProfile);
router.put("/user/profile", authMiddleware, updateProfile);
router.post("/user/change-password", authMiddleware, changePassword);
router.delete("/user/delete-account", authMiddleware, deleteAccount);

module.exports = router;
