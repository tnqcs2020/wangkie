function sendSuccess(res, message, data = {}, code = 200) {
  return res.status(code).json({
    success: true,
    code,
    message,
    data,
  });
}

function sendError(res, message, error = {}, code = 400) {
  const response = {
    success: false,
    code,
    message,
    data: null,
  };

  if (process.env.NODE_ENV === "development" && Object.keys(error).length) {
    response.error = error;
  }

  return res.status(code).json(response);
}

module.exports = { sendSuccess, sendError };
