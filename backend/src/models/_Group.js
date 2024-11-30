const { DataTypes, Model } = require('sequelize');
const sequelize = require('../config/database');
const { v4: uuidv4 } = require('uuid');
const Ajv = require('ajv');
const ajv = new Ajv();

class _Group extends Model {
  // Generate a random 7-character invite code
  static generateInviteCode() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let code = '';
    for (let i = 0; i < 7; i++) {
      code += characters.charAt(Math.floor(Math.random() * characters.length));
    }
    return code;
  }
}

const groupMemberListSchema = {
    type:'array',
    items:{
        type:'object',
        required:['UUID',"email"],
        properties:{
            UUID:{type:'string'},
            email:{type:'string'}
        }
    }

}

_Group.init(
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
    member_ids: {
      type: DataTypes.JSON, // Use JSON to store array-like data
      allowNull: true,
      defaultValue: [],
      validate:{
        isValidmemberList(value){
            const valid = ajv.compile(groupMemberListSchema);
            if(!valid(value)){
                let errorMessage = ajv.errorsText(valid.errors);
                throw new Error(`Invalid JSON for member_ids: ${errorMessage}`);
            }
        }
      }
    },
    group_code: {
      type: DataTypes.STRING(255),
      allowNull: false,
      unique: true,
      defaultValue: function () {
        return _Group.generateInviteCode(); // Generate invite code
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
    sequelize,
    modelName: '_Group',
    tableName: 'groups',
    hooks: {
      beforeCreate: (group) => {
        if (!group.group_code) {
          group.group_code = _Group.generateInviteCode();
        }
      },
    },
  }
);

module.exports = _Group;
