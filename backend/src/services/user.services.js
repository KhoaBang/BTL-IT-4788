const { UUID } = require("sequelize");
const _User = require("../models/_User");
const { findGroupById } = require("../services/group.services");
const { use } = require("../routes/auth.routes");
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
    user.changed("Personal_ingredient_list", true);
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
    user.changed("Personal_ingredient_list", true);
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
    user.changed("Tag_list", true);
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
    user.changed("Tag_list", true);
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

// Add new group to manger_of list of user
const addGroupToManagerList = async (uuid, GID) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }
    const groupList = user.manager_of || [];
    const groupData = await findGroupById(GID);
    const { GID: group_id, group_name } = groupData;
    // use some() for checking condition because it will return true when the condition is true
    const groupExists = groupList.some((group) => group.GID === group_id);
    if (groupExists) {
      throw new Error("Group already exists in manager list");
    }
    groupList.push({ GID: group_id, group_name: group_name });
    user.manager_of = groupList;
    user.changed("manager_of", true);
    await user.save();
  } catch (error) {
    throw new Error(`Error adding group to manager list: ${error.message}`);
  }
};

// Add new group to member_of list of user
/**
 * flow:
 * 1. Find user by UUID
 * 2. Check if user exists
 * 3. find group by GID
 * 4. Check if group exists
 * 5. get group name
 * 6. get member_of list of user
 * 7. check if the group exists in the list
 * 8. add the group to the list
 * 9. save the user
 */
const addGroupToMemberList = async (uuid, GID) => {
  try{
    const user = await _User.findOne({where:{UUID:uuid}});
    if(!user){
      throw new Error("User not found");
    }
    const groupData = await findGroupById(GID);
    const {GID:group_id,group_name} = groupData;
    const groupList = user.member_of || [];
    const groupExists = groupList.some((group) => group.GID === group_id);
    if(groupExists){
      throw new Error("Group already exists in member list");
    }
    groupList.push({GID:group_id,group_name:group_name});
    user.member_of = groupList;
    user.changed("member_of",true);
    await user.save();
  }catch(error){
    throw new Error(`Error adding group to member list: ${error.message}`);
  }
}

// delete group from member_of list of user
/**
 * flow:
 * 1. find user by UUID
 * 2. check if user exists
 * 3. get the group list of the user
 * 4. check if the group exists in the list
 * 5. remove the group from the list
 */
const deleteGroupFromMemberList = async (uuid, GID) => {
  try {
    // Fetch the user by UUID
    const user = await _User.findOne({ where: { UUID: uuid } });

    if (!user) {
      throw new Error("User not found");
    }

    user.member_of = user.member_of.filter((group) => group.GID !== GID);
    user.changed("member_of", true);
    await user.save();
  } catch (error) {
    throw new Error(`Error deleting group from member list: ${error.message}`);
  }
};


//delete group from manger_of list of user
/*
flow: 
1. find user by UUID
2. check if user exists
3. get the group list of the user
4. check if the group exists in the list
5. remove the group from the list
*/
const deleteGroupFromManagerList = async (uuid, GID) => {
  try {
    const user = await _User.findOne({ where: { UUID: uuid } });
    if (!user) {
      throw new Error("User not found");
    }
    const groupList = user.manager_of || [];
    const index = groupList.findIndex((group) => group.GID === GID);
    if (index === -1) {
      throw new Error("Group not found in manager list");
    }
    groupList.splice(index, 1);
    user.manager_of = groupList;
    user.changed("manager_of", true);
    await user.save();
  } catch (error) {
    throw new Error(`Error deleting group from manager list: ${error.message}`);
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
  // Export the user group list management services
  addGroupToManagerList,
  addGroupToMemberList,
  deleteGroupFromMemberList,
  deleteGroupFromManagerList,
};
