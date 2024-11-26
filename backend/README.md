#IT-4788
### UseCase tổng quan
![UseCase tổng quan](./assets/UseCaseTongQuan.png)

#IT-4788/quản_lý_thông_tin_người_dùng
### Usecase quản lý thông tin người dùng
![Usecase quản lý thông tin người dùng](./assets/UseCaseQuanLyNguoiDung.png)


| Method | URL                                       | Param type  | Param                                    | Description                                                                                                 | ROLE | require      |
| ------ | ----------------------------------------- | ----------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ---- | ------------ |
| get    | /userInfo/profile/me                      |             |                                          | người dùng lấy thông tin                                                                                    |      | requireLogin |
| post   | /userInfo/profile/update_info/me          | body        | { name, các trường thông tin,… }         | User cập nhật thông tin của chính mình (trừ số điện thoại và password).                                     |      | requireLogin |
| post   | /userInfo/update_pass/me                  | body        | { oldpass, newpass }                     | người dùng đặt lại mật khẩu                                                                                 |      | requireLogin |
| get    | /userInfo/store/ingredients/me?query      |             | { keyword, page, limit, tag, sort }      | người dùng lấy thông tin nguyên liệu trong kho cá nhân, hỗ trợ tra cứu nguyên liệu (theo keyword, theo tag) |      | requireLogin |
| post   | /userInfo/store/ingredients/              | body        | { ingredientId, các trường thông tin,… } | tạo nguyên liệu mới                                                                                         |      | requireLogin |
| put    | /userInfo/store/ingredients/:ingredientId | param,body  | { ingredientId, các trường thông tin,… } | cập nhật nguyên liệu cũ                                                                                     |      | requireLogin |
| del    | /userInfo/store/ingredients/:ingredientId | param       | ingredientId                             | Xóa nguyên liệu (xóa cứng)                                                                                  |      | requireLogin |
| get    | /userInfo/store/ingredients/tag?status=1  |             |                                          | xem danh sách tag nguyên liệu (các nguyên liệu có status=1)                                                 |      | requireLogin |
| post   | /userInfo/store/ingredients/tag           | body        | {tagName}                                | tạo tag nguyên liệu mới                                                                                     |      | requireLogin |
| put    | /userInfo/store/ingredients/tag/:tagId    | param,body  | tagId,{newtagName}                       | Chỉnh sửa tag                                                                                               |      | requireLogin |
| del    | /userInfo/store/ingredients/tag/:tagId    | param       | tagId                                    | xóa tag (có thể xóa mềm. thuộc tính status =1/0 rồi thực hiện validate ở front end)                         |      | requireLogin |
| post   | /userInfo/store/ingredients/addtag        | body        | {ingredientId, tagId}                    | add tag vào thực phẩm                                                                                       |      | requireLogin |
| post   | /userInfo/store/recipe                    | body        | {recipeName, info...}                    | tạo ct mới                                                                                                  |      | requireLogin |
| get    | /userInfo/store/recipe?keyword=           | query       |                                          | xem, tra cứu công thức                                                                                      |      | requireLogin |
| put    | /userInfo/store/recipe/:recipeId          | param, body | {updated info...}                        | cập nhật ct cũ                                                                                              |      | requireLogin |
| del    | /userInfo/store/recipe/:recipeId          | param       |                                          | xóa ct cũ                                                                                                   |      | requireLogin |

#IT-4788/quản_lý_thành_viên_nhóm 
### UseCase quản lý thành viên nhóm
![UseCase quản lý thành viên nhóm](./assets/UseCaseQuanLyThanhVien.png)

| Method | URL                                   | Param type | Param                         | Description                                                                            | ROLE | require                         |
| ------ | ------------------------------------- | ---------- | ----------------------------- | -------------------------------------------------------------------------------------- | ---- | ------------------------------- |
| post   | /group                                | body       | {groupName}                   | tạo nhóm                                                                               |      | requireLogin                    |
| get    | /group/:groupId/invite                |            |                               | lấy mã mời                                                                             |      | requireLogin, requireGroupAdmin |
| get    | /group/:groupId/members               |            |                               | lấy danh sách thành viên nhóm                                                          |      | requireLogin, requireMember     |
| patch  | /group/:groupId/members/:memberId/ban | body       | {memberId, reason}            | kick thành viên (cho vào blacklist/ remove khỏi danh sách thành viên?, mark là banned) |      | requireLogin ,requireGroupAdmin |
| POST   | /group/join?groupcode=                | query      | groupcode                     | tham gia nhóm                                                                          |      | requireLogin                    |
| delete | /group/:groupId/leave                 |            | get user id from cookie/token | rời nhóm                                                                               |      | requireLogin, requireMember     |
| patch  | /group/:groupId/delete                | body       | {status}                      | admin đóng nhóm, chuyển status của nhóm thành 'deleted'                                |      | equireLogin, requireGroupAdmin  |


#IT-4788/quản_lý_tài_nguyên_nhóm
### UseCase quản lý tài nguyên nhóm
![UseCase quản lý tài nguyên nhóm](./assets/UseCaseQuanLyTaiNguyen.png)


| Method | URL                            | Param type  | Param                                   | Description                                    | ROLE | require                         |
| ------ | ------------------------------ | ----------- | --------------------------------------- | ---------------------------------------------- | ---- | ------------------------------- |
| get    | /group/:groupId/fridge         |             |                                         | lấy danh sách đồ trong tủ lạnh                 |      | requireLogin, requireMember     |
| post   | /group/:groupId/fridge         | body        | {tên thực phẩm, số lượng, ngày mua,...} | thêm thực phẩm vào tủ lạnh                     |      | requireLogin, requireGroupAdmin |
| patch  | /group/:groupId/fridge/:itemId | param, body | {các trường thông tin cần thay đổi}     | chỉnh sửa thực phẩm trong tủ lạnh              |      | requireLogin, requireGroupAdmin |
| patch  | /group/:groupId/fridge/consume | body        | {thực phẩm Id, lượng tiêu thụ}          | tiêu thụ 1 lượng xác định thực phẩm từ tủ lạnh |      | requireLogin, requireGroupAdmin |
| delete | /group/:groupId/fridge/:itemId |             |                                         | xóa thực phẩm khỏi tủ lạnh                     |      | requireLogin, requireGroupAdmin |

#IT-4788/giao_nhiệm_vụ
### UseCase giao nhiệm vụ
![UseCase giao nhiệm vụ](./assets/UseCaseGiaoNhiemVu.png)


| Method | URL                                                        | Param type | Param                                          | Description                                                                                                                             | ROLE | require                         |
| ------ | ---------------------------------------------------------- | ---------- | ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- | ---- | ------------------------------- |
| post   | /group/:groupId/shoppinglist                               | body       | {shoppinglistName}                             | add shopping list                                                                                                                       |      | requireLogin, requireGroupAdmin |
| get    | /group/:groupId/shoppinglist/:listId                       |            |                                                | xem shopping list                                                                                                                       |      | requireLogin, requireMember     |
| delete | /group/:groupId/shoppinglist/:listId                       |            |                                                | xóa shopping list                                                                                                                       |      | requireLogin, requireGroupAdmin |
| patch  | /group/:groupId/shoppinglist/:listId                       | body       | {shoppinglistNewName}                          | Sửa tên shopping list                                                                                                                   |      | requireLogin, requireGroupAdmin |
| post   | /group/:groupId/shoppinglist/:listId/tasks                 | body       | {ingredientName, quantity, Assignee, deadline} | tạo task mua sắm                                                                                                                        |      | requireLogin, requireGroupAdmin |
| get    | /group/:groupId/shoppinglist/:listId/tasks?status=         | query      |                                                | xem các task trong list (cho phép lọc theo status (đã hoàn thành/ chưa hoàn thành))                                                     |      | requireLogin, requireMember     |
| delete | /group/:groupId/shoppinglist/:listId/tasks                 | body       | {taskId}                                       | xóa task                                                                                                                                |      | requireLogin, requireGroupAdmin |
| patch  | /group/:groupId/shoppinglist/:listId/task/:taskId          | body       | {các trường thông tin của task cần thay đổi}   | chỉnh sửa task                                                                                                                          |      | requireLogin, requireGroupAdmin |
| patch  | /group/:groupId/shoppinglist/:listId/task/:taskId/complete |            |                                                | dựa vào token/cookie để lấy userid, so sánh với assignee của task, nếu trùng ok, endpoint này để chuyển status của task thành completed |      | requireLogin, requireMember     |

#IT-4788/lập_kế_hoạch
### UseCase lập kế hoạch
![UseCase lập kế hoạch](./assets/UseCaseLapKeHoach.png)

| Method | URL                           | Param type | Param                                                 | Description      | ROLE | require                         |
| ------ | ----------------------------- | ---------- | ----------------------------------------------------- | ---------------- | ---- | ------------------------------- |
| post   | /group/:groupId/meals         | body       | {danh sách nguyên liệu, ngày ăn dự kiến}              | tạo bữa ăn       |      | requireLogin, requireGroupAdmin |
| get    | /group/:groupId/meals         |            |                                                       | xem các bữa ăn   |      | requireLogin, requireMember     |
| patch  | /group/:groupId/meals/:mealId | body       | {danh sách nguyên liệu thay đổi, các thuộc tính khác} | chỉnh sửa bữa ăn |      | requireLogin, requireGroupAdmin |
| delete | /group/:groupId/meals/:mealId |            |                                                       | Xóa bữa ăn       |      | requireLogin, requireGroupAdmin |

#IT-4788/auth
### UseCase auth

| Method | URL           | Param type | Param                             | Description                                         | ROLE | require      |
| ------ | ------------- | ---------- | --------------------------------- | --------------------------------------------------- | ---- | ------------ |
| post   | /auth/login   | body       | {phone, pass}                     | trả về jwt (encode thông tin user), lưu như cookie, |      |              |
| post   | /register     | body       | {các trường thông tin trong user} |                                                     |      |              |
| get    | /refreshToken |            |                                   | lấy về refresh token lưu vào local Storage          |      |              |
| post   | /auth/logout  |            |                                   |                                                     |      | requireLogin |

### UseCase admin (coming soon)