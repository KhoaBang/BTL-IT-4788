const { Router } = require("express");
const {
  requireAppLogin,
  requireMangager,
  requireMember,
} = require("../middleware/require-auth");
const {
  createShoppingList,
  getShoppingListById,
  updateShoppingListById,
  deleteShoppingListById,
  addTaskToShoppingList,
  getTaskById,
  updateTaskById,
  deleteTaskById,
} = require("../controllers/shopping.controller");

const router = Router();

/**
 * | post   | /group/:GID/shopping
 */
router.post(
  "/group/:GID/shopping",
  requireAppLogin,
  requireMangager,
  createShoppingList
);
router.get(
  "/group/:GID/shopping/:shopping_id",
  requireAppLogin,
  requireMember,
  getShoppingListById
);
router.delete(
  "/group/:GID/shopping/:shopping_id",
  requireAppLogin,
  requireMangager,
  deleteShoppingListById
);
router.patch(
  "/group/:GID/shopping/:shopping_id",
  requireAppLogin,
  requireMangager,
  updateShoppingListById
);
router.post(
  "/group/:GID/shopping/:shopping_id/task",
  requireAppLogin,
  requireMangager,
  addTaskToShoppingList
);
router.get(
  "/group/:GID/shopping/:shopping_id/task/:task_id",
  requireAppLogin,
  requireMember,
  getTaskById
);
router.delete(
  "/group/:GID/shopping/:shopping_id/task/:task_id",
  requireAppLogin,
  requireMangager,
  deleteTaskById
);
router.patch(
  "/group/:GID/shopping/:shopping_id/task/:task_id",
  requireAppLogin,
  requireMember,
  updateTaskById
);

module.exports = router;
