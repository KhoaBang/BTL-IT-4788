const { Router } = require("express");
const { requireAppLogin } = require("../middleware/require-auth");
const {
  getIngredientList,
  addIngredient,
  deleteIngredient,
  updateIngredient,
  getTagList,
  addTag,
  deleteTag,
  updateTag,
  matchTagAndIngredient,
  getUserProfile,
  updateUserProfile,
  updateUserPassword,
  getTaskList
} = require("../controllers/user.controller");

const router = Router();

// route chỉnh hồ sơ cá nhân
router.get("/userInfo/profile/me",requireAppLogin,getUserProfile);
router.post("/userInfo/profile/update_info/me",requireAppLogin,updateUserProfile);
router.post("/userInfo/update_pass/me",requireAppLogin, updateUserPassword);

// route chỉnh danh sách nguyên liệu
// nguyên liệu có dạng:
/**Sample:
 *  {
                "ingredient_name": "Mỳ ý",
                "unit_id": 2,
                "tags": [
                    {"tag_name": "Món ý"},
                    {"tag_name": "Món mì"}
                ]
            },
 */
router.get(
  "/userInfo/store/ingredients/me",
  requireAppLogin,
  getIngredientList
); // lấy danh sách nguyên liệu
router.post("/userInfo/store/ingredients", requireAppLogin, addIngredient); // tạo nguyên liệu thông tin để trong body (tag ở front- phải để droopdown)
router.delete("/userInfo/store/ingredients", requireAppLogin, deleteIngredient); // phải gửi nguyên liệu cũ trong body lên để tìm xóa
router.patch("/userInfo/store/ingredients", requireAppLogin, updateIngredient); // không có id nên phải gửi nguyên liệu cũ (tên) trong body để server tìm cập nhật
router.get("/userInfo/store/ingredients/tag", requireAppLogin, getTagList); // lấy danh sách tag
// router.get('/userInfo/store/ingredients/tag') // lấy danh sách tag
router.post("/userInfo/store/ingredients/tag", requireAppLogin, addTag); // tạo thêm tag
router.delete("/userInfo/store/ingredients/tag", requireAppLogin, deleteTag); // xóa tag, gửi tên tag cũ trong body
router.put("/userInfo/store/ingredients/tag", requireAppLogin, updateTag); // sửa tag, gửi tên tag cũ trong body
router.patch(
  "/userInfo/store/ingredients/add_tag",
  requireAppLogin,
  matchTagAndIngredient
); // thêm 1 tag vào 1 nguyên liệu -> gửi tên nguyên liệu + tên tag (đòi hỏi tag phải có sẵn)

// get all incompleted task
router.get("/userIfo/task", requireAppLogin, getTaskList);

// tương tác tag và nguyên liệu:
/**
 * thêm/bỏ nguyên liệu vào/khỏi tag (tương tác 1-1)
 * thêm/bỏ tag vào/khỏi nguyên liệu (tương tác 1-1)
 * do tương tác 1-1 nên chỉ cần lưu trực tiếp tag trong nguyên liệu
 * do lưu tag trong nguyên liệu nên việc xóa nguyên liệu không ảnh hưởng tag
 * nhưng việc xóa tag thì phải duyệt qua mọi nguyên liệu trong danh sách
 * việc sửa tag cũng phải duyệt qua mọi nguyên liệu trong danh sách
 * vậy khi chưa có nguyên liệu nào có tag? -> vẫn phải lưu 1 bảng tag
 * bảng tag có dạng: ["rau","thịt","hải sản","hương liệu","nguyên liệu nấu phở","nguyên liệu làm bánh","gia vị"]
 */
module.exports = router;
