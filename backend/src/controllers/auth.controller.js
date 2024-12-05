const { compare } = require('bcrypt');
const dotenv = require('dotenv');
const jwt = require('jsonwebtoken');
const sequelize= require('../config/database');
const {_Group,_User,_Unit} = sequelize.models

const { updateUserByUUID } = require('../services/user.services');
const { 
    NotAuthenticateError,
    BadRequestError,
    NotFoundError,
    InternalServerError,
    ForbiddenError,
} = require('../errors/error');

const bcrypt = require('bcrypt');

dotenv.config();

// hàm ký accesstoken
const signAccessToken = (payload) =>
  jwt.sign(payload, process.env.ACCESS_TOKEN_SECRET, {
    expiresIn: process.env.ACCESS_TOKEN_EXP,
  });
// hàm ký refresh_token 
//(refresh_token đực sinh ra mỗi lần người dùng đăng nhập, nếu người dùng đăng xuất thì refresh_token sẽ bị set thành 'EMPTY')
const signRefreshToken = (payload) =>
  jwt.sign(payload, process.env.REFRESH_TOKEN_SECRET, {
    expiresIn: process.env.REFRESH_TOKEN_EXP,
  });

/*
 * userLoginApp lấy email và password từ req.body, tìm user theo email, so sánh password,
     nếu đúng thì tạo access_token và refresh_token mới
     lưu refresh_token vào DB và trả về access_token và refresh_token
 */
 const userLoginApp = async (req, res, next) => {
    try {
    //lấy email và password từ req.body
      const { email, password } = req.body;
  // tìm user theo email
      const user = await _User.findOne({ where: { email } });

      if (!user||user.Status==='Blocked') {
        throw new NotFoundError('User not found.');
      }
      //so sánh password  
      const isPasswordMatch = await compare(password, user.password);
  
      if (!isPasswordMatch) {
        throw new BadRequestError('Invalid password.');
      }
      //tạo access_token và refresh_token mới
      const {UUID, username, email: userEmail, phone, role, ... restUserData}= user;
      const userPayload = {
        UUID,
        username,
        email: userEmail,
        phone,
        role,
      };
  
      const accessToken = signAccessToken(userPayload);
      const refreshToken = signRefreshToken(userPayload);
    //   lưu refresh_token vào DB
      const updatedData = await updateUserByUUID(userPayload.UUID, { refresh_token: refreshToken });
      req.Userdata = userPayload;
    //  trả về access_token và refresh_token
      res.status(200).json({
        status: 1,
        message: 'Login Successful',
        data: {
          refresh_token: refreshToken,
          access_token: accessToken,
          info: user,
        },
      })
    } catch (error) {
      console.log(_User);
      next(error);
    }
  }
/**
 * userLogoutApp lấy UUID từ req.Userdata, 
 * set refresh_token thành Empty trong DB và trả về thông báo logout thành công
 */
   const userLogoutApp = async (req, res, next) => {
    try {
      const { UUID } = req.Userdata;
      const updatedData = await updateUserByUUID(UUID, { refresh_token: 'EMPTY' });
      res.status(200).json({
        status: 1,
        message: 'Logout Successful',
      });
    } catch (error) {
      next(error);
    }
  }
  
/**
 * refreshAT:
 * Lấy refresh_token từ req.body, 
 * tra user theo refresh_token trong DB,
 *  Nếu thấy user: thì verify refresh_token trong DB, 
        * Nếu refresh_token không hợp lệ hoặc đã hết hạn:
            Cập nhật trường refresh_token của user thành rỗng (EMPTY).
            Ném lỗi TokenExpiredError.
            Thoát luồng xử lý.
        * Nếu refresh_token hợp lệ:
            lấy dữ liệu payload từ DB, 
            tạo access_token mới và trả về access_token.
* Nếu không tìm thấy user: thì ném lỗi NotFoundError, thoát luồng xử lý.
 */
 const refreshAT = async (req, res, next) => {
    const { refresh_token } = req.body;
    try {
      const user = await _User.findOne({ where: { refresh_token: refresh_token } });
      if (!user) {
        throw new NotFoundError('User not found.');
      }
      try {
        const decoded = jwt.verify(refresh_token, process.env.REFRESH_TOKEN_SECRET);
        const { UUID, username, email, phone, role } = decoded;
        const userPayload = {
          UUID,
          username,
          email,
          phone,
          role,
        };
        const accessToken = signAccessToken(userPayload);
        res.status(200).json({
          status: 1,
          message: 'Access token refreshed.',
          data: {
            access_token: accessToken,
          },
        });
      } catch (error) {
        await updateUserByUUID(user.UUID, { refresh_token: 'EMPTY' });
        throw new ForbiddenError('Token expired.');
      }
    } catch (error) {
      next(error);
    }
}

 const registerUser = async (req, res, next) => {
    try {
      const { username, email, password,phone  } = req.body;
      const user = await _User.findOne({ where: { email } });
      if (user) {
        throw new BadRequestError('Email already exists.');
      }
      // bcrypt password
      const hashedPassword = await bcrypt.hash(password, 10);
      const newUser = await _User.create({
        username,
        email,
        password:hashedPassword,
        phone
      }); 
      const { password:pass, ...restUserData } = newUser.dataValues;
      res.status(201).json({
        status: 1,
        message: 'User registered successfully',
        data: restUserData,

      });
    } catch (error) {
      next(error);
    }
}

module.exports = {userLoginApp,userLogoutApp,refreshAT,registerUser };