const { Router } = require('express');
const { requireAppLogin,requireMangager, requireMember  } = require('../middleware/require-auth');
const {
    getMeals,
    getMealById,
    createMeal,
    updateMeal,
    deleteMeal,
    convertMeal,
    consumeMeal 
  } = require ('../controllers/meal.controller')
const router = Router();

router.post('/group/:GID/meals',requireAppLogin,requireMangager,createMeal);
router.get('/group/:GID/meals',requireAppLogin,requireMangager,getMeals);//get all
router.get('/group/:GID/meals/:meal_id',requireAppLogin,requireMangager,getMealById);// get one
router.delete('/group/:GID/meals/:meal_id',requireAppLogin,requireMangager,deleteMeal)
router.post('/group/:GID/meals/:meal_id/convert',requireAppLogin,requireMangager,convertMeal)
router.patch('/group/:GID/meals/:meal_id',requireAppLogin,requireMangager,updateMeal)
router.patch('/group/:GID/meals/:meal_id/consume',requireAppLogin,requireMangager,consumeMeal)



module.exports = router;