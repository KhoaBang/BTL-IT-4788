const { Model } = require("sequelize");
const _Group = require("../models/_Group.js");
const {getUserByUUID}=require('../services/user.services')
const {
  createGroupservice,
  getGroupByGroupCode,
  updateGroupById,
  findGroupById
} = require("../services/group.services.js");
const {
  NotAuthenticateError,
  BadRequestError,
  NotFoundError,
  InternalServerError,
  ForbiddenError,
} = require("../errors/error");
const { join } = require("path");

const createGroup = async (req, res) => {
  const { UUID, ...restUserData } = req.Userdata;
  const { group_name } = req.body;
  if (!group_name)
    throw new BadRequestError(`Group name: ${group_name} is required.`);
  if (!UUID) {
    throw new NotAuthenticateError("You are not authenticated.");
  }
  try {
    const groupData = {
      group_name: group_name,
      manager_id: UUID,
    };
    const group = await createGroupservice(groupData);
    return res.status(201).json(group);
  } catch (error) {
    throw new InternalServerError(`Error creating group: ${error.message}`);
  }
};

const inviteCode = (req, res) => {
  return res.status(200).json({ group_code: req.Groupdata.group_code });
};

const joinGroup = async (req, res, next) => {
  const { group_code } = req.params;
  const { UUID } = req.Userdata;
    let Groupdata;
  try {
    Groupdata = await getGroupByGroupCode(group_code);
  } catch (error) {
    throw new BadRequestError(
      `no group with code ${group_code}: ${error.message}`
    );
  }

  const { GID } = Groupdata;
  if (Groupdata.member_ids.includes(UUID)) {
    throw new BadRequestError("You are already a member of this group");
  }
  if (Groupdata.manager_id === UUID) {
    throw new BadRequestError("You are the manager of this group");
  }
  const newMember = { UUID, email: req.Userdata.email };
  Groupdata.member_ids.push(newMember);
  try {
    await updateGroupById(GID, { member_ids: Groupdata.member_ids });
    res.status(200).json({ message: "You have successfully joined the group" });
  } catch (error) {
    throw new InternalServerError(`Error joining group: ${error.message}`);
  }
};

const listMembers = async (req, res, next) => {
  const { GID } = req.params;

  try {
    const group = await findGroupById(GID);
    if (!group) {
      throw new NotFoundError(`No group found with ID: ${GID}`);
    }

    const { member_ids } = group;

    // Use map with Promise.all to handle asynchronous operations
    const membersWithUsernames = await Promise.all(
      member_ids.map(async (element) => {
        const user = await getUserByUUID(element.UUID); // Fetch user data
        return {
          ...element, // Keep existing properties
          username: user.username, // Add username from user data
        };
      })
    );

    return res.status(200).json(membersWithUsernames);
  } catch (error) {
    next(error); // Forward error to the error handler
  }
};


module.exports = { createGroup, inviteCode, joinGroup, listMembers };
