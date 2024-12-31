const { Sequelize } = require("sequelize");
const sequelize = require("../config/database");
const {
  BadRequestError,
  NotFoundError,
  InternalServerError,
  ForbiddenError,
} = require("../errors/error");
const { findGroupById } = require("../services/group.services");
const { sendPushNotification } = require("../services/push.services");

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

//get all shopping list
const getAllShoppingList = async (req, res, next) => {
  const { GID } = req.params;
  try {
    const shoppingList = await sequelize.models._Shopping.findAll({
      where: { GID },
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

// get all task in a shopping list
const getTaskInShoppingList = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  try {
    const shoppingList = await sequelize.models._Shopping.findOne({
      where: { GID, shopping_id },
    });
    if (!shoppingList) throw new NotFoundError("Shopping list not found.");

    const task_list = shoppingList.task_list || [];
    const tasks = await sequelize.models._Task.findAll({
      where: { task_id: task_list },
    });

    return res.status(200).json(tasks);
  } catch (error) {
    next(error);
  }
};

// Add a task to a shopping list
const addTaskToShoppingList = async (req, res, next) => {
  const { GID, shopping_id } = req.params;
  const { ingredient_name, unit_id, assigned_to, quantity } = req.body;

  try {
    // Fetch the shopping list
    const shoppingList = await sequelize.models._Shopping.findOne({
      where: { GID, shopping_id },
    });
    if (!shoppingList) throw new NotFoundError("Shopping list not found.");

    // Fetch the group data
    const group = await sequelize.models._Group.findOne({ where: { GID } });
    if (!group) {
      throw new BadRequestError(`No group found with ID: ${GID}`);
    }

    // Check if user is a group member or manager
    const isMember = group.member_ids?.some(
      (member) => member.UUID === assigned_to
    );
    const isManager = group.manager_id === assigned_to;

    if (!(isMember || isManager)) {
      throw new ForbiddenError("You are not authorized to assign this task.");
    }

    // Create the new task
    const task = await sequelize.models._Task.create({
      ingredient_name,
      unit_id,
      assigned_to,
      quantity,
    });

    // Update the shopping list
    const taskList = shoppingList.getDataValue("task_list") || [];
    taskList.push(task.task_id);
    shoppingList.setDataValue("task_list", taskList);
    shoppingList.changed("task_list", true);
    await shoppingList.save();

    const unit = await sequelize.models._Unit.findOne({
      where: { id: unit_id },
    });

    //send notice to assignee
    sendPushNotification(
      "You got new task",
      `ingredient: ${ingredient_name}; unit: ${unit.unit_name}; quantity: ${quantity}`,
      assigned_to
    );

    // Respond with the created task
    return res.status(201).json(task);
  } catch (error) {
    // Pass error to middleware
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
    const updatedFields = {};
    for (const key of Object.keys(updates)) {
      if (
        allowedUpdates.includes(key) &&
        updates[key] !== null &&
        updates[key] !== undefined
      ) {
        updatedFields[key] = updates[key];
      }
    }

    // Update the task using the allowed updates
    await task.update(updatedFields);

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

//member completed task
const memCompleteTask = async (req, res, next) => {
  const { task_id } = req.params;
  try {
    const { UUID } = req.Userdata;
    const task = await sequelize.models._Task.findOne({
      where: { task_id: task_id },
    });
    if (task.assigned_to === UUID) {
      task.status = "completed";
      task.changed("status", true);
      task.save();
      return res.status(200).json({ message: "Complete successfully" });
    } else throw new ForbiddenError("not your task");
  } catch (err) {
    next(err);
  }
};

// Get all tasks
const getAllTask = async (req, res, next) => {
  const { shopping_id, GID } = req.params;
  const list = await sequelize.models._Shopping.findOne({
    where: { shopping_id, GID },
  });
  const task_list = list?.task_list || [];
  const tasks = [];
  try {
    for (let i = 0; i < task_list.length; i++) {
      const task = await sequelize.models._Task.findOne({
        where: { task_id: task_list[i] },
      });
      const { task_id, ingredient_name, unit_id, updatedAt, status, quantity } =
        task;
      const assignee = await sequelize.models._User.findOne({
        where: { UUID: task.assigned_to },
      });
      const unit = await sequelize.models._Unit.findOne({
        where: { id: unit_id },
      });
      const { username, email } = assignee;
      tasks.push({
        task_id,
        ingredient_name,
        unit_id,
        updatedAt,
        username,
        email,
        status,
        unit,
        quantity,
      });
    }
    return res.status(200).json(tasks);
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
  memCompleteTask,
  getAllShoppingList,
  getTaskInShoppingList,
  getAllTask,
};
