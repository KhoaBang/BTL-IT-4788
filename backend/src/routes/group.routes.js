const { Router } = require('express');
const { requireAppLogin,requireMangager, requireMember  } = require('../middleware/require-auth');
const {createGroup,inviteCode, joinGroup, listMembers}=require('../controllers/group.controller');
const router = Router();

router.post('/group',requireAppLogin,createGroup);
router.get(`/group/:GID/invite`,requireAppLogin,requireMangager, inviteCode);
router.post(`/group/join/:group_code`,requireAppLogin, joinGroup);
router.get(`/group/:GID/members`,requireAppLogin,requireMember,listMembers)
///group/:GID/members/:memberId/ban
///group/:GID/leave
///group/:GID/delete

module.exports = router;