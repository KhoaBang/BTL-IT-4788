const { DataTypes } = require("sequelize");
const { v4: uuidv4 } = require("uuid");
const Ajv = require("ajv");
const ajv = new Ajv();

const createInviteCode = () => {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let code = '';
    for (let i = 0; i < 7; i++) {
      code += characters.charAt(Math.floor(Math.random() * characters.length));
    }
    return code;
  }

// Define and compile AJV schemas once
const groupMemberListSchema = {
  type: "array",
  items: {
    type: "object",
    required: ["UUID", "email"],
    properties: {
      UUID: { type: "string" },
      email: { type: "string" },
    },
  },
};
const valideMemberList = ajv.compile(groupMemberListSchema);

const groupBlacklistSchema = {
  type: "array",
  items: {
    type: "object",
    properties: {
      UUID: { type: "string" },
    },
  },
};
const valideBlacklist = ajv.compile(groupBlacklistSchema);

// main function
module.exports = async (sequelize) => {
  return await sequelize.define(
    "_Group",
    {
      GID: {
        type: DataTypes.UUID,
        defaultValue: () => uuidv4(),
        primaryKey: true,
      },
      group_name: {
        type: DataTypes.STRING(255),
        allowNull: false,
        validate: {
          notEmpty: true,
        },
      },
      manager_id: {
        type: DataTypes.UUID,
        allowNull: false,
        validate: {
          notEmpty: true,
        },
      },
      blacklist: {
        type: DataTypes.JSON,
        allowNull: true,
        defaultValue: [],
        validate: {
          isValidBlacklist(value) {
            if (!valideBlacklist(value)) {
              const errorMessage = ajv.errorsText(valideBlacklist.errors);
              throw new Error(`Invalid JSON for blacklist: ${errorMessage}`);
            }
          },
        },
      },
      member_ids: {
        type: DataTypes.JSON, // Use JSON to store array-like data
        allowNull: true,
        defaultValue: [],
        validate: {
          isValidmemberList(value) {
            if (!valideMemberList(value)) {
              const errorMessage = ajv.errorsText(valideMemberList.errors);
              throw new Error(`Invalid JSON for member_ids: ${errorMessage}`);
            }
          },
        },
      },
      group_code: {
        type: DataTypes.STRING(255),
        allowNull: false,
        unique: true,
        defaultValue: function () {
          const characters =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
          let code = "";
          for (let i = 0; i < 7; i++) {
            code += characters.charAt(
              Math.floor(Math.random() * characters.length)
            );
          }
          return code;
        },
        validate: {
          len: [7, 7], // Ensure invite code is exactly 7 characters
          isAlphanumeric: true, // Ensure the code is alphanumeric
        },
      },
      createdAt: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      updatedAt: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      tableName: "groups",
      hooks: {
        beforeCreate: (group) => {
          if (!group.group_code) {
            group.group_code = createInviteCode();
          }
        },
      },
    }
  );
};

/**Sample:
 *  {
                "ingredient_name": "Mỳ ý",
                "unit_id": 2,
                "tags": [
                    {"tag_name": "Món ý"},
                    {"tag_name": "Món mì"}
                ]
            },
 */



// _Group.init(
//   {
//     GID: {
//       type: DataTypes.UUID, // Use UUID type instead of INTEGER
//       defaultValue: uuidv4, // Automatically generate UUID
//       primaryKey: true,
//     },
//     groupname: {
//       type: DataTypes.STRING(255),
//       allowNull: false,
//       validate: {
//         notEmpty: true,
//       },
//     },
//   },
//   {
//     sequelize,
//     modelName: "_Group",
//     tableName: "groups",
//     timestamps: false,
//   }
// );

// module.exports = _Group;