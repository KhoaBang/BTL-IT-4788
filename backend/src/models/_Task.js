const { default: def } = require("ajv/dist/vocabularies/discriminator");
const { DataTypes } = require("sequelize");

module.exports = async (sequelize) => {
  return await sequelize.define(
    "_Task",
    {
      assigned_to: {
        type: DataTypes.UUID,
        allowNull: true,
        defaultValue:""
      },
      task_id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4, // Use Sequelize's built-in UUID generator
        primaryKey: true,
      },
      ingredient_name: {
        type: DataTypes.STRING,
        allowNull: false,
        validate: {
          notEmpty: true,
        },
      },
      unit_id: {
        type: DataTypes.INTEGER, // Validation removed as `notEmpty` is not applicable for integers
        allowNull: false,
      },
      status: {
        type: DataTypes.STRING,
        defaultValue: "not completed",
      },
      quantity: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
    },
    {
      tableName: "tasks",
      timestamps: true, // Automatically adds `createdAt` and `updatedAt`
      charset: "utf8", // Ensures UTF-8 encoding
      collate: "utf8_unicode_ci", // Ensures proper Unicode collation
    }
  );
};
