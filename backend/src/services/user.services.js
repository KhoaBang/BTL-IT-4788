const _User = require('../models/_User');
/*
user management services
*/

// Create a new user
const createUser = async (userData) => {
  try {
    const user = await _User.create(userData);
    return user;
  } catch (error) {
    throw new Error(`Error creating user: ${error.message}`);
  }
};

// Get user by UUID (or any other unique identifier)
const getUserByUUID = async (uuid) => {
  try {
    const user = await _User.findOne({
      where: { UUID: uuid },
    });
    return user;
  } catch (error) {
    throw new Error(`Error fetching user by UUID: ${error.message}`);
  }
};

// Get user by email
const getUserByEmail = async (email) => {
  try {
    const user = await _User.findOne({
      where: { email: email },
    });
    return user;
  } catch (error) {
    throw new Error(`Error fetching user by email: ${error.message}`);
  }
};

// Update a user by UUID
const updateUserByUUID = async (uuid, updatedData) => {
  try {
    const [updatedRows] = await _User.update(updatedData, {
      where: { UUID: uuid },
    });
    return updatedRows > 0;
  } catch (error) {
    throw new Error(`Error updating user by UUID: ${error.message}`);
  }
};

// Delete a user by UUID
const deleteUserByUUID = async (uuid) => {
  try {
    const deletedRows = await _User.destroy({
      where: { UUID: uuid },
    });
    return deletedRows > 0;
  } catch (error) {
    throw new Error(`Error deleting user by UUID: ${error.message}`);
  }
};

// Get all users (optionally with pagination)
const getAllUsers = async (limit = 10, offset = 0) => {
  try {
    const users = await _User.findAll({
      limit,
      offset,
    });
    return users;
  } catch (error) {
    throw new Error(`Error fetching all users: ${error.message}`);
  }
};

/*
user ingredient list management services
*/

const addIngredientToUserList = async (uuid, ingredient) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }

    const ingredientList = user.Personal_ingredient_list || [];
    ingredientList.push(ingredient);

    user.Personal_ingredient_list = ingredientList;
    await user.save();

    return user.Personal_ingredient_list;
  } catch (error) {
    throw new Error(`Error adding ingredient to user list: ${error.message}`);
  }
};

// Remove an ingredient from the user's ingredient list
const removeIngredientFromUserList = async (uuid, ingredientName) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }

    const ingredientList = user.Personal_ingredient_list || [];
    const updatedList = ingredientList.filter(
      (ingredient) => ingredient.ingredient_name !== ingredientName
    );

    user.Personal_ingredient_list = updatedList;
    await user.save();

    return user.Personal_ingredient_list;
  } catch (error) {
    throw new Error(
      `Error removing ingredient from user list: ${error.message}`
    );
  }
};

// Get the user's ingredient list
const getUserIngredientList = async (uuid) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }

    return user.Personal_ingredient_list;
  } catch (error) {
    throw new Error(`Error fetching user ingredient list: ${error.message}`);
  }
};

/*
user tag list management services
*/

// Add a tag to the user's tag list
const addTagToUserList = async (uuid, tag) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }

    const tagList = user.Tag_list || [];
    tagList.push(tag);

    user.Tag_list = tagList;
    await user.save();

    return user.Tag_list;
  } catch (error) {
    throw new Error(`Error adding tag to user list: ${error.message}`);
  }
};

// Remove a tag from the user's tag list
const removeTagFromUserList = async (uuid, tagId) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }

    const tagList = user.Tag_list || [];
    const updatedList = tagList.filter((tag) => tag.tag_id !== tagId);

    user.Tag_list = updatedList;
    await user.save();

    return user.Tag_list;
  } catch (error) {
    throw new Error(`Error removing tag from user list: ${error.message}`);
  }
};

// Get the user's tag list
const getUserTagList = async (uuid) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }

    return user.Tag_list;
  } catch (error) {
    throw new Error(`Error fetching user tag list: ${error.message}`);
  }
};

module.exports = {
  createUser,
  getUserByUUID,
  getUserByEmail,
  updateUserByUUID,
  deleteUserByUUID,
  getAllUsers,
  // Export the user ingredient list management services
  addIngredientToUserList,
  removeIngredientFromUserList,
  getUserIngredientList,
  // Export the user tag list management services
  addTagToUserList,
  removeTagFromUserList,
  getUserTagList,
};
