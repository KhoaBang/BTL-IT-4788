const { Router } = require('express');
const { requireAppLogin,requireMangager, requireMember  } = require('../middleware/require-auth');
const {createGroup,inviteCode, joinGroup, listMembers, leaveGroup, banMember,deleteGroup,getGroupList}=require('../controllers/group.controller');
const router = Router();

router.post('/group',requireAppLogin,createGroup);
router.get('/group',requireAppLogin,getGroupList);
router.get(`/group/:GID/invite`,requireAppLogin,requireMangager, inviteCode);
router.post(`/group/join/:group_code`,requireAppLogin, joinGroup);
router.get(`/group/:GID/members`,requireAppLogin,requireMember,listMembers)
router.post('/group/:GID/leave',requireAppLogin,requireMember,leaveGroup)
router.post('/group/:GID/members/ban',requireAppLogin,requireMangager,banMember)
router.delete('/group/:GID',requireAppLogin,requireMangager,deleteGroup)

module.exports = router;