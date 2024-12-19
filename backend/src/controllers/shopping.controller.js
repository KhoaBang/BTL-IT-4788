const sequelize = require("../config/database");
const {
  BadRequestError,
  NotFoundError,
  InternalServerError,
  ForbiddenError,
} = require("../errors/error");
const { findGroupById } = require("../services/group.services");

// Create a new shopping list
const createShoppingList = async (req, res, next) => {
  const { GID } = req.params;
  const { name } = req.body;
  try {
    if (!name) throw new BadRequestError("Shopping list name is required.");
    const group = await findGroupById(GID);
    if (!group) throw new NotFoundError("Group not found.");

    const shoppingList = await sequelize.models._Shopping.create({ GID, name });
    return res.status(201).json(shoppingList);
  } catch (error) {
    next(error);
  }
};

// Get a shopping list by ID
const getShoppingListById = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  try {
    const shoppingList = await sequelize.models._Shopping.findOne({
      where: { GID, shopping_id },
    });
    if (!shoppingList) throw new NotFoundError("Shopping list not found.");
    return res.status(200).json(shoppingList);
  } catch (error) {
    next(error);
  }
};

// Update a shopping list info (not task) by ID
const updateShoppingListById = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  const { name, status } = req.body;
  try {
    const shoppingList = await sequelize.models._Shopping.findOne({
      where: { GID, shopping_id },
    });
    if (!shoppingList) throw new NotFoundError("Shopping list not found.");

    if (name) shoppingList.name = name;
    if (status) shoppingList.status = status;

    await shoppingList.save();
    return res.status(200).json(shoppingList);
  } catch (error) {
    next(error);
  }
};

// Delete a shopping list by ID
const deleteShoppingListById = async (req, res, next) => {
  const { GID, shopping_id } = req.params;

  try {
    // Find the shopping list by GID and shopping_id
    const shoppingList = await sequelize.models._Shopping.findOne({
      where: { GID, shopping_id },
    });

    if (!shoppingList) {
      throw new NotFoundError("Shopping list not found.");
    }

    // Retrieve the task_list
    const task_list = shoppingList.task_list || [];

    // Delete associated tasks if any exist
    if (task_list.length > 0) {
      for (const task_id of task_list) {
        const task = await sequelize.models._Task.findOne({
          where: { task_id },
        });
        if (task) {
          await task.destroy();
        }
      }
    }

    // Delete the shopping list
    await shoppingList.destroy();

    // Send a success response
    return res
      .status(200)
      .json({ message: "Shopping list deleted successfully" });
  } catch (error) {
    // Pass the error to the next middleware
    next(error);
  }
};

// Add a task to a shopping list
const addTaskToShoppingList = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  const { ingredient_name, unit_id, assigned_to, quantity } = req.body;
  try {
    const shoppingList = await sequelize.models._Shopping.findOne({
      where: { GID, shopping_id },
    });
    if (!shoppingList) throw new NotFoundError("Shopping list not found.");
    // check if assigned_to is member of the group:
    try {
      Groupdata = await sequelize.models._Group.findOne({
        where: { GID: GID },
      });
      if (!!!Groupdata) {
        throw new BadRequestError(`No group found with ID: ${GID}`);
      }
    } catch (error) {
      return next(
        new BadRequestError(
          `Error fetching group with ID ${GID}: ${error.message}`
        )
      );
    }

    // Check if user is a member or the manager of the group
    let isMember = Groupdata.member_ids.some((member) => member.UUID === assigned_to);
    const isManager = Groupdata.manager_id === assigned_to;

    if (!(isMember || isManager)) {
      throw new ForbiddenError("You are not a member of this group");
    }
    const task = await sequelize.models._Task.create({
      ingredient_name,
      unit_id,
      assigned_to,
      quantity,
    });
    shoppingList.task_list.push(task.task_id);
    shoppingList.changed("task_list", true);
    await shoppingList.save();

    return res.status(201).json(task);
  } catch (error) {
    next(error);
  }
};

// Get a task by ID
const getTaskById = async (req, res, next) => {
  const { task_id } = req.params;
  try {
    const task = await sequelize.models._Task.findOne({ where: { task_id } });
    if (!task) throw new NotFoundError("Task not found.");
    return res.status(200).json(task);
  } catch (error) {
    next(error);
  }
};

// Update a task by ID
const updateTaskById = async (req, res, next) => {
  const { task_id } = req.params;
  const allowedUpdates = [
    "ingredient_name",
    "unit_id",
    "quantity",
    "assigned_to",
    "status",
  ]; // Define allowed fields
  const updates = req.body;

  try {
    // Find the task by task_id
    const task = await sequelize.models._Task.findOne({ where: { task_id } });
    if (!task) {
      throw new NotFoundError("Task not found.");
    }

    // Dynamically update only allowed fields that are not null
    for (const key of Object.keys(updates)) {
      if (
        allowedUpdates.includes(key) &&
        updates[key] !== null &&
        updates[key] !== undefined
      ) {
        task[key] = updates[key];
      }
    }

    // Save the updated task
    await task.save();

    // Respond with the updated task
    return res.status(200).json(task);
  } catch (error) {
    next(error);
  }
};

// Delete a task by ID
const deleteTaskById = async (req, res, next) => {
  const { task_id } = req.params;
  try {
    const task = await sequelize.models._Task.findOne({ where: { task_id } });
    if (!task) throw new NotFoundError("Task not found.");

    await task.destroy();
    return res.status(200).json({ message: "Task deleted successfully" });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createShoppingList,
  getShoppingListById,
  updateShoppingListById,
  deleteShoppingListById,
  addTaskToShoppingList,
  getTaskById,
  updateTaskById,
  deleteTaskById,
};

/**
 * const sequelize = require('../config/database');
const { _Shopping, _Task, _Group } = sequelize.models;
const { BadRequestError, NotFoundError, InternalServerError, ForbiddenError } = require('../errors/error');
const { getUserByUUID } = require('../services/user.services');
const { findGroupById } = require('../services/group.services');

// Create a new shopping list
const createShoppingList = async (req, res, next) => {
  const { GID } = req.params;
  const { name } = req.body;
  try {
    if (!name) throw new BadRequestError('Shopping list name is required.');
    const group = await findGroupById(GID);
    if (!group) throw new NotFoundError('Group not found.');

    const shoppingList = await sequelize.models._Shopping.create({ GID, name });
    return res.status(201).json(shoppingList);
  } catch (error) {
    next(error);
  }
};

// Get a shopping list by ID
const getShoppingListById = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  try {
    const shoppingList = await _Shopping.findOne({ where: { GID, shopping_id } });
    if (!shoppingList) throw new NotFoundError('Shopping list not found.');
    return res.status(200).json(shoppingList);
  } catch (error) {
    next(error);
  }
};

// Update a shopping list by ID
const updateShoppingListById = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  const { name, status } = req.body;
  try {
    const shoppingList = await _Shopping.findOne({ where: { GID, shopping_id } });
    if (!shoppingList) throw new NotFoundError('Shopping list not found.');

    if (name) shoppingList.name = name;
    if (status) shoppingList.status = status;

    await shoppingList.save();
    return res.status(200).json(shoppingList);
  } catch (error) {
    next(error);
  }
};

// Delete a shopping list by ID
const deleteShoppingListById = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  try {
    const shoppingList = await _Shopping.findOne({ where: { GID, shopping_id } });
    if (!shoppingList) throw new NotFoundError('Shopping list not found.');

    await shoppingList.destroy();
    return res.status(200).json({ message: 'Shopping list deleted successfully' });
  } catch (error) {
    next(error);
  }
};

// Add a task to a shopping list
const addTaskToShoppingList = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  const { ingredient_name, unit_id, assigned_to } = req.body;
  try {
    const shoppingList = await _Shopping.findOne({ where: { GID, shopping_id } });
    if (!shoppingList) throw new NotFoundError('Shopping list not found.');

    const task = await _Task.create({ ingredient_name, unit_id, assigned_to });
    shoppingList.task_list.push(task.task_id);
    shoppingList.changed('task_list', true);
    await shoppingList.save();

    return res.status(201).json(task);
  } catch (error) {
    next(error);
  }
};

// Get a task by ID
const getTaskById = async (req, res, next) => {
  const { GID, shopping_id, task_id } = req.params;
  try {
    const task = await _Task.findOne({ where: { task_id } });
    if (!task) throw new NotFoundError('Task not found.');
    return res.status(200).json(task);
  } catch (error) {
    next(error);
  }
};

// Update a task by ID
const updateTaskById = async (req, res, next) => {
  const { GID, shopping_id, task_id } = req.params;
  const { ingredient_name, unit_id, status } = req.body;
  try {
    const task = await _Task.findOne({ where: { task_id } });
    if (!task) throw new NotFoundError('Task not found.');

    if (ingredient_name) task.ingredient_name = ingredient_name;
    if (unit_id) task.unit_id = unit_id;
    if (status) task.status = status;

    await task.save();
    return res.status(200).json(task);
  } catch (error) {
    next(error);
  }
};

// Delete a task by ID
const deleteTaskById = async (req, res, next) => {
  const { GID, shopping_id, task_id } = req.params;
  try {
    const task = await _Task.findOne({ where: { task_id } });
    if (!task) throw new NotFoundError('Task not found.');

    await task.destroy();
    return res.status(200).json({ message: 'Task deleted successfully' });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  createShoppingList,
  getShoppingListById,
  updateShoppingListById,
  deleteShoppingListById,
  addTaskToShoppingList,
  getTaskById,
  updateTaskById,
  deleteTaskById,
};
 */
