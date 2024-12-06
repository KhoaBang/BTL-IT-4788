const { Router } = require('express');
const { requireAppLogin,requireMangager, requireMember } = require('../middleware/require-auth');
const {ingredientList, addIngred,updateIngred,deleteIngred,consumeIngred} = require('../controllers/fridge.controller');
const router = Router();

router.get('/group/:GID/fridge',requireAppLogin,requireMember,ingredientList)//lấy danh sách đồ trong tủ lạnh
router.post('/group/:GID/fridge',requireAppLogin,requireMangager,addIngred)//thêm thực phẩm vào tủ lạnh
router.patch('/group/:GID/fridge',requireAppLogin,requireMangager,updateIngred)//chỉnh sửa thực phẩm trong tủ lạnh
router.delete('/group/:GID/fridge',requireAppLogin,requireMangager,deleteIngred)//chỉnh sửa thực phẩm trong tủ lạnh
router.patch('/group/:GID/fridge/consume',requireAppLogin,requireMember,consumeIngred)//tiêu thụ 1 lượng xác định thực phẩm từ tủ lạnh
// fridge có dạng:
/**
[
  {
    "ingredient_name": "Mỳ ý",
    "unit_id": 2,
    "detail": [
      {
        "quantity": 2,
        "createdAt": "2024-12-01" // chỉ có ngày theo format yyyy-mm-dd
      },
      {
        "quantity": 3,
        "createdAt": "2024-12-03"
      }
    ]
  }
]

/*
get	/group/:groupId/fridge  lấy danh sách đồ trong tủ lạnh
post	/group/:groupId/fridge  thêm thực phẩm vào tủ lạnh
patch	/group/:groupId/fridge/:itemId  chỉnh sửa thực phẩm trong tủ lạnh
patch	/group/:groupId/fridge/consume  tiêu thụ 1 lượng xác định thực phẩm từ tủ lạnh
delete	/group/:groupId/fridge/:itemId  xóa thực phẩm khỏi tủ lạnh
 */


module.exports = router;
