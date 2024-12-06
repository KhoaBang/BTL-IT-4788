const { Router } = require('express');
const { requireAppLogin,requireMangager, requireMember } = require('../middleware/require-auth');
const {ingredientList} = require('../controllers/fridge.controller');
const router = Router();

router.get('/group/:GID/fridge',requireAppLogin,requireMember,ingredientList)//lấy danh sách đồ trong tủ lạnh
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
