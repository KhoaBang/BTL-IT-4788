const sequelize = require("../config/database");
const {
  BadRequestError,
  NotFoundError,
  InternalServerError,
  ForbiddenError,
} = require("../errors/error");

const createRecipe = async (req, res, next) => {
    try {
      const { UUID } = req.Userdata;
      const { recipe } = req.body;
      let {
        name,
        description = "",
        prep_time_minutes = 0,
        cook_time_minutes = 0,
        servings = 0,
        ingredients = [],
        steps = [],
        notes = "",
      } = recipe;
  
      if (!name) {
        throw new BadRequestError("Recipe name is required.");
      }
  
      name = name.toLowerCase();
  
      const user = await sequelize.models._User.findOne({ where: { UUID } });
      if (!user) {
        throw new NotFoundError("User not found.");
      }
  
      const recipe_list = user.recipe_list || [];
  
      // Check if recipe name is unique
      if (recipe_list.some((r) => r.name === name)) {
        throw new BadRequestError("Recipe name must be unique.");
      }
  
      // Add recipe to the user's recipe list
      recipe_list.push({
        name,
        description,
        prep_time_minutes,
        cook_time_minutes,
        servings,
        ingredients,
        steps,
        notes,
      });
  
      // Add new ingredients to personal_ingredient_list
      const personal_ingredient_list = user.personal_ingredient_list || [];
      const personalIngredientSet = new Set(
        personal_ingredient_list.map((ing) => ing.ingredient_name.toLowerCase())
      );
  
      const newIngredients = ingredients.filter(
        (ing) => !personalIngredientSet.has(ing.ingredient_name.toLowerCase())
      );
  
      newIngredients.forEach(({ ingredient_name, unit_id }) => {
        personal_ingredient_list.push({
          ingredient_name: ingredient_name.toLowerCase(),
          unit_id,
        });
      });
  
      user.recipe_list = recipe_list;
      user.personal_ingredient_list = personal_ingredient_list;
      user.changed("recipe_list",true)
      user.changed("personal_ingredient_list",true)
      // Save updated user data
      await user.save();
  
      res.status(201).json({ message: "Recipe created successfully.",recipe });
    } catch (error) {
      next(error);
    }
  };

  const getRecipe = async (req, res, next) => {
    const { UUID } = req.Userdata;
    const { getAll = false, recipe_name } = req.query; // Use req.query for query parameters
    try {
      const user = await sequelize.models._User.findOne({ where: { UUID } });
      if (!user) {
        throw new NotFoundError("User not found.");
      }
  
      const recipe_list = user.recipe_list || [];
  
      if (getAll==="true") {
        // Return a list of all recipe names
        const res_recipe = recipe_list.map((recipe) => ({
          recipe_name: recipe.name,
        }));
        return res.status(200).json(res_recipe);
      }
  
      // Find the specific recipe by name
      if (!recipe_name) {
        throw new BadRequestError("Recipe name is required when getAll is false.");
      }
  
      const recipe = recipe_list.find(
        (r) => r.name.toLowerCase() === recipe_name.toLowerCase()
      );
  
      if (!recipe) {
        throw new NotFoundError(`Recipe with name '${recipe_name}' not found.`);
      }
  
      return res.status(200).json(recipe);
    } catch (error) {
      next(error);
    }
  };

  const updateRecipe = async (req, res, next) => {
    const { UUID } = req.Userdata;
    const { old_recipe_name, new_recipe } = req.body;
  
    try {
      // Validate the input
      if (!old_recipe_name || !new_recipe || !new_recipe.name) {
        throw new BadRequestError("Missing or invalid recipe data.");
      }
  
      const user = await sequelize.models._User.findOne({ where: { UUID } });
      if (!user) {
        throw new NotFoundError("User not found.");
      }
  
      const recipe_list = user.recipe_list || [];
      // Find the recipe to update
      const recipeIndex = recipe_list.findIndex(
        (r) => r.name.toLowerCase() === old_recipe_name.toLowerCase()
      );
  
      if (recipeIndex === -1) {
        throw new NotFoundError(
          `Recipe with name '${old_recipe_name}' not found.`
        );
      }
  
      // Check if the new recipe name conflicts with an existing recipe
      const isDuplicateName = recipe_list.some(
        (r, index) =>
          r.name.toLowerCase() === new_recipe.name.toLowerCase() &&
          index !== recipeIndex
      );
  
      if (isDuplicateName) {
        throw new BadRequestError("Recipe name must be unique.");
      }
  
      // Update the recipe
      recipe_list[recipeIndex] = {
        ...recipe_list[recipeIndex], // Retain existing fields
        ...new_recipe, // Overwrite with new data
        name: new_recipe.name.toLowerCase(), // Ensure name is lowercase
      };

      const new_ingre_list = new_recipe.ingredients||[]
      const personal_ingredient_list = user.personal_ingredient_list ||[]
      const newIngredients = new_ingre_list.filter(
        (ing) =>
          !personal_ingredient_list.some(
            (personal_ing) =>
              personal_ing.ingredient_name.toLowerCase() ===
              ing.ingredient_name.toLowerCase()
          )
      );
      
  
      newIngredients.forEach(({ ingredient_name, unit_id }) => {
        personal_ingredient_list.push({
          ingredient_name: ingredient_name.toLowerCase(),
          unit_id,
        });
      });
  
      // Save changes to the user
      user.recipe_list = recipe_list;
      user.changed("recipe_list", true);
      user.changed("personal_ingredient_list",true)
      await user.save();
  
      return res
        .status(200)
        .json({ message: "Recipe updated successfully", recipe: recipe_list[recipeIndex] });
    } catch (error) {
      next(error);
    }
  };

  const deleteRecipe = async (req, res, next) => {
    const { UUID } = req.Userdata;
    const { recipe_name } = req.body;
  
    try {
      // Validate input
      if (!recipe_name) {
        throw new BadRequestError("Recipe name is required.");
      }
  
      // Find user
      const user = await sequelize.models._User.findOne({ where: { UUID } });
      if (!user) {
        throw new NotFoundError("User not found.");
      }
  
      const recipe_list = user.recipe_list || [];
  
      // Find the index of the recipe to delete
      const recipeIndex = recipe_list.findIndex(
        (r) => r.name.toLowerCase() === recipe_name.toLowerCase()
      );
  
      if (recipeIndex === -1) {
        throw new NotFoundError(
          `Recipe with name '${recipe_name}' not found.`
        );
      }
  
      // Remove the recipe from the list
      const deletedRecipe = recipe_list.splice(recipeIndex, 1)[0];
  
      // Save the updated recipe list
      user.recipe_list = recipe_list;
      user.changed("recipe_list", true);
      await user.save();
  
      return res
        .status(200)
        .json({ message: "Recipe deleted successfully", recipe: deletedRecipe });
    } catch (error) {
      next(error);
    }
  };

  module.exports={
    createRecipe,
    getRecipe,
    updateRecipe,
    deleteRecipe
  }
  