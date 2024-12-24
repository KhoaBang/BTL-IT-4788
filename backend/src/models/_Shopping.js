const { DataTypes } = require("sequelize");
const Ajv = require("ajv");
const addFormats = require("ajv-formats");

const ajv = new Ajv();
addFormats(ajv);

const task_listSchema = {
  type: "array",
  items: {
    // Use "items" instead of "item"
    type: "string", // UUIDs are strings
    format: "uuid", // Use the "uuid" format provided by ajv-formats
  },
};
const validateTask_listSchema = ajv.compile(task_listSchema);

(module.exports = async (sequelize) => {
  return await sequelize.define(
    "_Shopping", {
    GID: {
      type: DataTypes.UUID,
      allowNull: false,
    },
    shopping_id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4, // Use Sequelize's built-in UUID generator
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING, // Use Sequelize DataType
      allowNull: false,
    },
    createdAt: {
      type: DataTypes.DATE, // Use correct type
      defaultValue: sequelize.NOW
    },
    task_list: {
      type: DataTypes.JSON,
      defaultValue: [],
      validate: {
        isValidTaskList(value) {
          if (!validateTask_listSchema(value)) {
            const errorMessage = ajv.errorsText(validateTask_listSchema.errors);
            throw new Error(`Invalid JSON for task_list: ${errorMessage}`);
          }
        },
      },
    },
    status: {
      type: DataTypes.STRING,
      defaultValue: "open",
    },
  },
  {
    tableName: "shoppings",
    timestamps: true,
    charset: "utf8",
    collate: "utf8_unicode_ci",
  }
);
  
})
  
