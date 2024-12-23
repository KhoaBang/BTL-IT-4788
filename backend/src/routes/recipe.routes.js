const { Router } = require('express');
const { requireAppLogin } = require('../middleware/require-auth');
const {
    createRecipe,
    getRecipe,
    updateRecipe,
    deleteRecipe
  } = require ('../controllers/recipe.controller')

const router = Router();

router.post("/userInfo/store/recipe",requireAppLogin,createRecipe)
router.get("/userInfo/store/recipe",requireAppLogin,getRecipe) ///userInfo/store/recipe?recipe_name="..."; userInfo/store/recipe?getAll=true
router.put("/userInfo/store/recipe",requireAppLogin,updateRecipe)
router.delete("/userInfo/store/recipe",requireAppLogin,deleteRecipe)

module.exports = router;