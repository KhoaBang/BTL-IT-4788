const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const {
  NotAuthenticateError,
  ForbiddenError,
} = require('../errors/error');

dotenv.config();

/**
 * lấy authorization từ req
 * trích xuất token từ authorization
 * verify token và gán payload vào req.Userdata
 */

const  requireAppLogin = (req, res, next) => {
  try {
    // Check if Authorization header is present
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      throw new NotAuthenticateError('You are not authenticated.');
    }

    // Extract the token from the Authorization header
    const token = authHeader.split(' ')[1];
    if (!token) {
      throw new NotAuthenticateError('Authorization token is malformed.');
    }

    // Verify the token
    const payload = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

    // Attach the payload to the request object for downstream usage
    req.Userdata = payload;
    next(); // Pass control to the next middleware or route
  } catch (error) {
    // Handle token errors with specific responses
    if (error.name === 'TokenExpiredError') {
      next(new ForbiddenError('Token expired.'));
    } else if (error.name === 'JsonWebTokenError') {
      next(new ForbiddenError('Invalid token.'));
    } else if (error.name === 'NotBeforeError') {
      next(new ForbiddenError('Token not yet valid.'));
    } else {
      next(error); // For any other errors
    }
  }
};
module.exports = { requireAppLogin };