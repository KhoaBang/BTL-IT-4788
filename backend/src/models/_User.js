
const { DataTypes } = require('sequelize');
const Ajv = require('ajv');
const { v4: uuidv4 } = require('uuid');
const { default: def } = require('ajv/dist/vocabularies/discriminator');

const ajv = new Ajv();

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
const ingredientSchema = {
  type: 'array',
  items: {
    type: 'object',
    required: ['ingredient_name', 'unit_id'],
    properties: {
      ingredient_name: { type: 'string' },
      unit: { type: 'number' },
      tags:{ 
        type: 'array',
        default: [],
        items:{
          type: 'object',
          properties: {
            tag_name: { type: 'string' },
          }
        }
       },
    },
  },
};

// sample: ["rau","thịt","hải sản","hương liệu","nguyên liệu nấu phở","nguyên liệu làm bánh","gia vị"]
const tagSchema = {
  type: 'array',
  default: [],
  items: {
    type: 'string',
  },
};

const groupListSchema = {
  type: 'array',
  items: {
    type: 'object',
    required: ['GID', 'group_name'],
    properties: {
      GID: { type: 'string' },
      group_name: { type: 'string' },
    },
  },
}

module.exports = async (sequelize) => {
  return await sequelize.define(
    '_User',
    {
      UUID: {
        type: DataTypes.UUID, // Use UUID type
        defaultValue: uuidv4, // Automatically generate UUID
        primaryKey: true,
      },
      username: {
        type: DataTypes.STRING(255),
        allowNull: false,
        validate: {
          notEmpty: true,
        },
      },
      dob: {
        type: DataTypes.DATEONLY,
        allowNull: true,
        defaultValue: null,
      },
      email: {
        type: DataTypes.STRING(255),
        allowNull: false,
        unique: true,
        validate: {
          isEmail: true,
          notEmpty: true,
        },
      },
      password: {
        type: DataTypes.STRING(255),
        allowNull: false,
        validate: {
          notEmpty: true,
        },
      },
      tag_list: {
        type: DataTypes.JSON,
        defaultValue: [],
        allowNull: true,
        validate: {
          isJson(value) {
            const validateTag = ajv.compile(tagSchema);
            if (!validateTag(value)) {
              console.error('Validation errors:', validateTag.errors);
              const tagErrorMessage = ajv.errorsText(validateTag.errors);
              throw new Error(`Invalid JSON for tag_list: ${tagErrorMessage}`);
            }
          },
        },
      },
      personal_ingredient_list: {
        type: DataTypes.JSON,
        defaultValue: [],
        allowNull: true,
        validate: {
          isValidJson(value) {
            const validate = ajv.compile(ingredientSchema);
            if (!validate(value)) {
              console.error('Validation errors:', validate.errors);
              const errorMessage = ajv.errorsText(validate.errors);
              throw new Error(`Invalid JSON for personal_ingredient_list: ${errorMessage}`);
            }
          },
        },
      },
      phone: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true, // Corrected from `isUnique`
        validate: {
          notEmpty: true,
        },
      },
      role: {
        type: DataTypes.STRING(50),
        allowNull: false,
        defaultValue: 'User',
      },
      refresh_token: {
        type: DataTypes.STRING(512),
        allowNull: true,
        defaultValue: 'EMPTY',
      },
      status: {
        type: DataTypes.STRING(50),
        allowNull: false,
        defaultValue: 'Active',
      },
      member_of: {
        type: DataTypes.JSON,
        defaultValue: [],
        allowNull: true,
        validate: {
          isValidJson(value) {
            const validate = ajv.compile(groupListSchema);
            if (!validate(value)) {
              console.error('Validation errors:', validate.errors);
              const errorMessage = ajv.errorsText(validate.errors);
              throw new Error(`Invalid JSON for member_of: ${errorMessage}`);
            }
          },
        },
      },
      manager_of: {
        type: DataTypes.JSON,
        defaultValue: [],
        allowNull: true,
        validate: {
          isValidJson(value) {
            const validate = ajv.compile(groupListSchema);
            if (!validate(value)) {
              console.error('Validation errors:', validate.errors);
              const errorMessage = ajv.errorsText(validate.errors);
              throw new Error(`Invalid JSON for manager_of: ${errorMessage}`);
            }
          },
        },
      },
    },
    {
      tableName: 'users',
      timestamps: false,
    }
  );
};