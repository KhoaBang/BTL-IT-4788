const sequelize= require('../config/database');
const {_Group,_User,_Unit} = sequelize.models

// Create a new group
const createGroupservice = async (groupData) => {
  try {
    const group = await _Group.create(groupData);
    return group;
  } catch (error) {
    throw new Error(`Error creating group: ${error.message}`);
  }
};

// Find a group by ID
const findGroupById = async (groupId) => {
  try {
    const group = await _Group.findByPk(groupId);
    if (!group) {
      throw new Error('Group not found');
    }
    return group;
  } catch (error) {
    throw new Error(`Error finding group: ${error.message}`);
  }
};

// Update a group by ID
const updateGroupById = async (groupId, updateData) => {
  try {
    const group = await _Group.findByPk(groupId);
    if (!group) {
      throw new Error('Group not found');
    }
    await group.update(updateData);
    return group;
  } catch (error) {
    throw new Error(`Error updating group: ${error.message}`);
  }
};

// Delete a group by ID
const deleteGroupById = async (groupId) => {
  try {
    const group = await _Group.findByPk(groupId);
    if (!group) {
      throw new Error('Group not found');
    }
    await group.destroy();
    return { message: 'Group deleted successfully' };
  } catch (error) {
    throw new Error(`Error deleting group: ${error.message}`);
  }
};
//get group by groupcode
const getGroupByGroupCode = async (groupCode) => {
  try {
    const group = await _Group.findOne({
      where: { group_code: groupCode },
    });
    return group;
} catch (error) {
    throw new Error(`Error fetching group by group code: ${error.message}`);
  }
}

// Find all groups
const findAllGroups = async () => {
  try {
    const groups = await _Group.findAll();
    return groups;
  } catch (error) {
    throw new Error(`Error finding groups: ${error.message}`);
  }
};

module.exports = {
  createGroupservice,
  findGroupById,
  updateGroupById,
  deleteGroupById,
  findAllGroups,
  getGroupByGroupCode
};