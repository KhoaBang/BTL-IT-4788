const sequelize= require('../config/database');
const {_Group,_User,_Unit} = sequelize.models

const {
  getUserByUUID,
  addGroupToManagerList,
  addGroupToMemberList,
  deleteGroupFromMemberList,
  deleteGroupFromManagerList,
} = require("../services/user.services");
const {
  createGroupservice,
  getGroupByGroupCode,
  updateGroupById,
  findGroupById,
} = require("../services/group.services.js");
const {
  NotAuthenticateError,
  BadRequestError,
  NotFoundError,
  InternalServerError,
  ForbiddenError,
} = require("../errors/error");

/*
 * Create a new group:
 * +, tao group moi voi manager_id la UUID cua user
 * +, them GID vao manger_of cua user
 */
const createGroup = async (req, res,next) => {
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
    await addGroupToManagerList(UUID, group.GID);
    return res.status(201).json(group);
  } catch (error) {
    next(error);
  }
};

const inviteCode = (req, res) => {
  return res.status(200).json({ group_code: req.Groupdata.group_code });
};

/**
 * Join a group using a group code
 * khi nguoi dung join group thi:
 * +,Kiem tra xem user co phai la manager/member cua group do khong
 * +, kiem tra xem neu user bi ban
 * +,Them UUID vao member_ids cua group
 * +,Them GID vao member_of cua user
 *
 */
const joinGroup = async (req, res, next) => {
  const { group_code } = req.params;
  const { UUID } = req.Userdata;
  try {
    let Groupdata;

    Groupdata = await getGroupByGroupCode(group_code);

    //check dieu kien de join group
    let isMember = false;
    if (
      Groupdata.manager_id === UUID ||
      Groupdata.member_ids.some((member) => member.UUID === UUID)
    ) {
      isMember = true;
    }
    if (isMember) {
      throw new ForbiddenError("You are already a member of this group.");
    }
    if (Groupdata.blacklist.some((member) => member.UUID === UUID)) {
      throw new ForbiddenError("You are banned from this group.");
    }
    // thoa man dieu kien, -> thuc hien them UUID vao member_ids cua group, them GID vao member_of cua user

    const newMember = await _User.findOne({where:{UUID:UUID}});
    //thuc hien them UUID vao member_ids cua group
    Groupdata.member_ids.push({ UUID: UUID, email: newMember.email });
    Groupdata.changed('member_ids', true);
    await Groupdata.save();

    //them GID vao member_of cua user
     newMember.member_of.push({
      GID: Groupdata.GID,
      group_name: Groupdata.group_name,
    });
    newMember.changed('member_of', true);
    const result = await newMember.update({member_of: newMember.member_of});
    console.log(result)
    res.status(200).json({ message: "Joined group successfully" });
  } catch (error) {
    next(error);
  }
};

const listMembers = async (req, res, next) => {
  const { GID } = req.params;

  try {
    const group = await sequelize.models._Group.findByPk(GID);
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
    next(error);
  }
};

const leaveGroup = async (req, res, next) => {
  try {
    const { UUID } = req.Userdata;
    const { GID } = req.params;

    // Retrieve the group details
    const group = await findGroupById(GID);
    if (!group) {
      throw new NotFoundError("Group not found");
    }

    const { manager_id, member_ids } = group;

    // Ensure the manager cannot leave the group
    if (manager_id === UUID) {
      throw new ForbiddenError("Manager cannot leave the group");
    }

    // Find the index of the member in the member_ids list
    const memberIndex = member_ids.findIndex((member) => member.UUID === UUID);
    if (memberIndex === -1) {
      throw new NotFoundError("User is not a member of the group");
    }

    // Remove the user from the member list
    member_ids.splice(memberIndex, 1);

    // Update the group and user records
    await updateGroupById(GID, { member_ids });
    user = await getUserByUUID(UUID);
    await deleteGroupFromMemberList(UUID, GID);

    // Send a success response
    return res.status(200).json({ message: "Left group successfully" });
  } catch (error) {
    // Pass the error to the error-handling middleware
    next(error);
  }
};

// ban user
/*
 * flow: get UUID of user to ban from req.body
 * find group by GID
 * push UUID to blacklist of group
 * delete member with said UUID from member_ids of group
 * delete group from member_of of user
 */
const banMember = async (req, res, next) => {
  try {
    const { UUID } = req.body;
    const { GID } = req.params;
    //find group by GID
    console.log(GID);
    const group = await sequelize.models._Group.find({where:{GID:GID}});
    const { blacklist, member_ids } = group;
    //push UUID to blacklist of group
    const isBanned = blacklist.some((member) => member.UUID === UUID);
    if (isBanned) {
      throw new ForbiddenError("User is already banned");
    }
    blacklist.push({ UUID: UUID });
    //delete member with said UUID from member_ids of group
    const index = member_ids.findIndex((member) => member.UUID === UUID);
    if (index === -1) {
      throw new NotFoundError("User not found in group");
    }
    member_ids.splice(index, 1);
    try {
      await updateGroupById(GID, {
        blacklist: blacklist,
        member_ids: member_ids,
      });
      await deleteGroupFromMemberList(UUID, GID);
      return res.status(200).json({ message: "User banned successfully" });
    } catch (error) {
      throw new InternalServerError(`Error banning user: ${error.message}`);
    }
  } catch (error) {
    next(error);
  }
};

//delete group
/*
flow:
1. get GID from req.params
2. find group by GID
3. get member_ids of group
4. get manager_id of group
5. delete group from member_of of all members
6. delete group from manager_of of manager
7. delete group
8. delete all group resources
*/
const deleteGroup = async (req, res, next) => {
  const { GID } = req.params;
  const group = await findGroupById(GID);
  const { manager_id, member_ids } = group;
  try {
    //delete group from member_of of all members
    await Promise.all(
      member_ids.map(async (member) => {
        await deleteGroupFromMemberList(member.UUID, GID);
      })
    );
    //delete group from manager_of of manager
    await deleteGroupFromManagerList(manager_id, GID);
    //delete group
    await group.destroy();
    return res.status(200).json({ message: "Group deleted successfully" });
  } catch (error) {
    next(error);
  }
};
module.exports = {
  createGroup,
  inviteCode,
  joinGroup,
  listMembers,
  leaveGroup,
  banMember,
  deleteGroup,
};
