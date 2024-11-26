const { Router } = require('express');
const { userLoginApp, userLogoutApp, refreshAT, registerUser } = require('../controllers/auth.controller');
const { loginSchema, refreshSchema, validateReq, registerSchema } = require('../middleware/validate');
const { requireAppLogin } = require('../middleware/require-auth');

const router = Router();
router.post('/auth/login', validateReq(loginSchema), userLoginApp);
router.post('/auth/logout', requireAppLogin, userLogoutApp);
router.post('/refreshToken', validateReq(refreshSchema), refreshAT);
router.post('/register', validateReq(registerSchema), registerUser);

module.exports = router;