const { DataTypes, Model } = require('sequelize');
const sequelize = require('../config/database');
const Ajv = require('ajv');
const { v4: uuidv4 } = require('uuid');

const ajv = new Ajv();

// sample:    { "ingredient_name": "Salt", "unit": "grams", "tagid": "1" },
const ingredientSchema = {
  type: 'array',
  items: {
    type: 'object',
    required: ['ingredient_name', 'unit'],
    properties: {
      ingredient_name: { type: 'string' },
      unit: { type: 'string' },
      tagid:{ type: ['string', 'null'] },
    },
  },
};

// sample: { "tag_id": "2", "tag_name": "Sweetener", "description": "Adds sweetness" }
const tagSchema = {
  type: 'array',
  items: {
    type: 'object',
    required: ['tag_id', 'tag_name'],
    properties: {
      tag_id: { type: 'string' },
      tag_name: { type: 'string' },
      description:{ type: ['string', 'null'] },
    },
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

class _User extends Model {}

_User.init(
  {
    UUID: {
      type: DataTypes.UUID,   // Use UUID type instead of INTEGER
      defaultValue: uuidv4,   // Automatically generate UUID
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
            let validateTag = ajv.compile(tagSchema)
          if (!validateTag(value)) {
             console.error('Validation errors:', validateTag.errors);
            let tagErrorMessage = ajv.errorsText(validateTag.errors);
            throw new Error(`Invalid JSON for taglist: ${tagErrorMessage}`);
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
          let validate = ajv.compile(ingredientSchema);
          if (!validate(value)) {
            console.error('Validation errors:', validate.errors);
            let errorMessage = ajv.errorsText(validate.errors);
            throw new Error(`Invalid JSON for Personal_ingredient_list: ${errorMessage}`);
          }
        },
      },
    },
    phone: {
      type: DataTypes.STRING(50),
      allowNull: false,
        isUnique: true,
      validate: {
        notEmpty: true,
      },
    },
    role:{
      type: DataTypes.STRING(50),
      allowNull: false,
      defaultValue: 'User',
    },
    refresh_token: {
      type: DataTypes.STRING(512),
      allowNull: true,
      defaultValue: 'EMPTY',
    },
    status:{
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
          let validate = ajv.compile(groupListSchema);
          if (!validate(value)) {
            console.error('Validation errors:', validate.errors);
            let errorMessage = ajv.errorsText(validate.errors);
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
          let validate = ajv.compile(groupListSchema);
          if (!validate(value)) {
            console.error('Validation errors:', validate.errors);
            let errorMessage = ajv.errorsText(validate.errors);
            throw new Error(`Invalid JSON for manager_of: ${errorMessage}`);
          }
        },
      },
    },
  },
  {
    sequelize,
    modelName: '_User',
    tableName: 'users',
    timestamps: false,
  }
);


module.exports = _User;
