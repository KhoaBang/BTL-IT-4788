const sequelize = require("../config/database");
const {
  BadRequestError,
  NotFoundError,
  InternalServerError,
  ForbiddenError,
} = require("../errors/error");

// Get all meals for a group
const getMeals = async (req, res, next) => {
  const { GID } = req.params;
  try {
    const meals = await sequelize.models._Meal.findAll({ where: { GID } });
    res.status(200).json(meals);
  } catch (error) {
    next(error);
  }
};

// Get a meal by ID
const getMealById = async (req, res, next) => {
  const { GID, meal_id } = req.params;
  try {
    const meal = await sequelize.models._Meal.findOne({
      where: { GID, meal_id },
    });
    if (!meal) throw new NotFoundError("Meal not found.");
    res.status(200).json(meal);
  } catch (error) {
    next(error);
  }
};

// Create a new meal
const createMeal = async (req, res, next) => {
  const { GID } = req.params;
  const { ingredient_list, consume_date,meal_name } = req.body;
  try {
    const meal = await sequelize.models._Meal.create({
      GID,
      ingredient_list,
      consume_date,
      meal_name,
    });
    res.status(201).json(meal);
  } catch (error) {
    next(error);
  }
};

// Update a meal by ID
const updateMeal = async (req, res, next) => {
  const { GID, meal_id } = req.params;
  const updates = req.body;
  const allowedUpdates = ["ingredient_list", "consume_date","meal_name"]; // Define allowed fields

  try {
    // Find the meal by GID and meal_id
    const meal = await sequelize.models._Meal.findOne({
      where: { GID, meal_id },
    });
    if (!meal) {
      throw new NotFoundError("Meal not found.");
    }

    // Dynamically update only allowed fields that are not null or undefined
    for (const key of Object.keys(updates)) {
      if (
        allowedUpdates.includes(key) &&
        updates[key] !== null &&
        updates[key] !== undefined
      ) {
        meal[key] = updates[key];
      }
    } 

    // Save the updated meal
    await meal.save();

    // Respond with the updated meal
    return res.status(200).json(meal);
  } catch (error) {
    // Pass the error to the next middleware
    next(error);
  }
};

// Delete a meal by ID
const deleteMeal = async (req, res, next) => {
  const { GID, meal_id } = req.params;
  try {
    const meal = await sequelize.models._Meal.findOne({
      where: { GID, meal_id },
    });
    if (!meal) throw new NotFoundError("Meal not found.");

    await meal.destroy();
    res.status(200).json({ message: "Meal deleted successfully" });
  } catch (error) {
    next(error);
  }
};

const convertMeal = async (req, res, next) => {
  const { GID, meal_id } = req.params;

  try {
    // Fetch the meal
    const meal = await sequelize.models._Meal.findOne({
      where: { GID, meal_id },
    });
    if (!meal) throw new NotFoundError("Meal not found.");

    const { ingredient_list, meal_name } = meal;

    // Create a new shopping list
    const shoppingList = await sequelize.models._Shopping.create({
      GID,
      name: meal_name,
    });

    // Initialize task list
    const task_list = shoppingList.getDataValue("task_list") || [];

    // Create tasks for each ingredient
    for (let i = 0; i < ingredient_list.length; i++) {
      const { ingredient_name, unit_id, quantity } = ingredient_list[i];
      const task = await sequelize.models._Task.create({
        ingredient_name,
        unit_id,
        quantity,
      });
      task_list.push(task.task_id);
    }

    // Update shopping list's task list
    shoppingList.setDataValue("task_list", task_list);
    await shoppingList.save();

    // Respond with the created shopping list
    return res.status(201).json(shoppingList);
  } catch (error) {
    next(error);
  }
};

const consumeMeal = async(req,res,next)=>{
    const { GID,meal_id } = req.params;
    try{
      const meal = await sequelize.models._Meal.findOne({where:{ GID,meal_id }})
      //get ingredient_list in meal
      const ingredient_list = meal.ingredient_list || []
      if(ingredient_list.length <1){
        throw new BadRequestError("no ingredient in meal")
      }
      //get the fridge
      const groupData = await sequelize.models._Group.findOne({where:{GID}})
      const fridge = groupData.fridge || []
      if(fridge.length <1){
        throw new BadRequestError("no ingredient in fridge")
      }
      //sort fridge, ingredient_list by name first: descending
      fridge.sort((ingred_a,ingred_b)=>ingred_a.ingredient_name>ingred_b.ingredient_name) 
      ingredient_list.sort((ingred_a,ingred_b)=>ingred_a.ingredient_name>ingred_b.ingredient_name)
      //function to subtract ingredient:
      // loop over all the ingredient in meal, if fridge contain it then sutract (smallest date first)
      for(let i =0; i<ingredient_list.length;i++){ //loop over all the ingredient in meal
        const ingredient = ingredient_list[i]
        let  subtract_amount = ingredient.quantity ||0
        for(let j =0; j<fridge.length;j++){ //loop over all the ingredient in fridge
            const fridge_ingred = fridge[j]
            if(fridge_ingred.ingredient_name<ingredient.ingredient_name) continue // because fridge is sorted by name -> can eascape early if unable finding matching ingredient name
            else if (fridge_ingred.ingredient_name>ingredient.ingredient_name) break // eascape early
            else if(fridge_ingred.ingredient_name===ingredient.ingredient_name){ //when found
                let sum_quantity = fridge_ingred.detail.reduce((acc, item) => acc + item.quantity, 0); // cal current amount in fridge
                if(subtract_amount>=sum_quantity){ 
                    fridge.splice(j,1)
                }else{
                    fridge_ingred.detail.sort((a,b)=> new Date(a.createdAt)-new Date(b.createdAt))
                    while(subtract_amount>0){
                        if(subtract_amount<fridge_ingred.detail[0].quantity){
                            fridge_ingred.detail[0].quantity= fridge_ingred.detail[0].quantity- subtract_amount
                            subtract_amount=0
                        }
                        else{
                            subtract_amount= subtract_amount- fridge_ingred.detail[0].quantity
                            fridge_ingred.detail.splice(0,1)
                        }
                    }
                }    
            }
        }
      }
      // save fridge after consumtion
      groupData.fridge=fridge
      groupData.changed("fridge",true)
      await groupData.save()
      res.status(200).json(fridge)
    }catch(error){
      next(error)
    }
  
  }

module.exports = {
    getMeals,
    getMealById,
    createMeal,
    updateMeal,
    deleteMeal,
    convertMeal,
    consumeMeal
  };