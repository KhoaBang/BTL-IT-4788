const { Router } = require('express');
const { userLoginApp, userLogoutApp, refreshAT, registerUser } = require('../controllers/auth.controller');
const { loginSchema, refreshSchema, validateReq, registerSchema } = require('../middleware/validate');
const { requireAppLogin } = require('../middleware/require-auth');

const router = Router();
router.post('/app/auth/login', validateReq(loginSchema), userLoginApp);
router.post('/app/auth/logout', requireAppLogin, userLogoutApp);
router.post('/app/auth/refresh_token', validateReq(refreshSchema), refreshAT);
router.post('/register', validateReq(registerSchema), registerUser);

module.exports = router;