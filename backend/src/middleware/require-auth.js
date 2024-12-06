const jwt = require("jsonwebtoken");
const dotenv = require("dotenv");
const { NotAuthenticateError, ForbiddenError,BadRequestError } = require("../errors/error");
const sequelize= require('../config/database');
const {_Group,_User,_Unit} = sequelize.models

const { findGroupById } = require("../services/group.services");

dotenv.config();

/**
 * lấy authorization từ req
 * trích xuất token từ authorization
 * verify token và gán payload vào req.Userdata
 */

const requireAppLogin = (req, res, next) => {
  try {
    // Check if Authorization header is present
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      throw new NotAuthenticateError("You are not authenticated.");
    }

    // Extract the token from the Authorization header
    const token = authHeader.split(" ")[1];
    if (!token) {
      throw new NotAuthenticateError("Authorization token is malformed.");
    }

    // Verify the token
    const payload = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

    // Attach the payload to the request object for downstream usage
    req.Userdata = payload;
    next(); // Pass control to the next middleware or route
  } catch (error) {
    // Handle token errors with specific responses
    if (error.name === "TokenExpiredError") {
      next(new ForbiddenError("Token expired."));
    } else if (error.name === "JsonWebTokenError") {
      next(new ForbiddenError("Invalid token."));
    } else if (error.name === "NotBeforeError") {
      next(new ForbiddenError("Token not yet valid."));
    } else {
      next(error); // For any other errors
    }
  }
};

const requireMangager = async (req, res, next) => {
  const { GID } = req.params;
  const { UUID } = req.Userdata;
  const Groupdata = await _Group.findOne({ where: { GID: GID } });
  if (!!!Groupdata) {
    next(new BadRequestError(`No group found with ID: ${GID}`));
  }
  req.Groupdata = Groupdata;
  console.log("day la : " + GID);
  if (Groupdata?.manager_id !== UUID) {
    next(new ForbiddenError("You are not the manager of this group"));
  } else next();
};

const requireMember = async (req, res, next) => {
  const { GID } = req.params;
  const { UUID } = req.Userdata;

  let Groupdata; // Declare outside the try block
  try {
    const Groupdata = await _Group.findOne({ where: { GID: GID } });
    if (!!!Groupdata) {
      throw new BadRequestError(`No group found with ID: ${GID}`);
    }
  } catch (error) {
    return next(
      new BadRequestError(
        `Error fetching group with ID ${GID}: ${error.message}`
      )
    );
  }

  // Check if user is a member or the manager of the group
  let isMember = Groupdata.member_ids.some((member) => member.UUID === UUID);
  const isManager = Groupdata.manager_id === UUID;

  if (isMember || isManager) {
    req.Groupdata = Groupdata; // Attach group data to request
    return next(); // Proceed to the next middleware
  } else {
    return next(new ForbiddenError("You are not a member of this group"));
  }
};

module.exports = { requireAppLogin, requireMangager, requireMember };
