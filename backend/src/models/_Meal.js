const { DataTypes } = require("sequelize");
const Ajv = require("ajv");
const addFormats = require("ajv-formats")
const ajv = new Ajv();
addFormats(ajv)

const ingredientListSchema = {
    type : "array",
    items:{
      type:"object",
      required:["ingredient_name","unit_id"],
      properties:{
        ingredient_name:{type:"string"},
        unit_id:{"type":"number"},
        quantity:{type:"number"},
      }
    }
  }
  const validateIngredientList = ajv.compile(ingredientListSchema);

  module.exports = async (sequelize) => {
    return await sequelize.define(
      "_Meal",
      {
        GID: {
            type: DataTypes.UUID,
            allowNull: false,
          },
        meal_id: {
          type: DataTypes.UUID,
          defaultValue: DataTypes.UUIDV4, 
          primaryKey: true,
        },
        ingredient_list: {
          type: DataTypes.JSON,
          allowNull: true,
          defaultValue:[],
          validate: {
            isValidIngredientList(value){
            if(!validateIngredientList(value)){
                const errorMessage = ajv.errorsText(validateIngredientList.errors);
              throw new Error(`Invalid JSON for ingredent list: ${errorMessage}`);
            }
            }
          },
        },
        meal_name:{
          type: DataTypes.STRING,
          allowNull:false,
          defaultValue:" "
        },
        consume_date: {
          type: DataTypes.DATE,
          allowNull: true, // Allows null values
          validate: {
            isDate: true, // Ensures the value is a valid date
          },
        }
      },
      {
        tableName: "meals",
        timestamps: true, // Automatically adds `createdAt` and `updatedAt`
        charset: "utf8", // Ensures UTF-8 encoding
        collate: "utf8_unicode_ci", // Ensures proper Unicode collation
      }
    );
  };
  