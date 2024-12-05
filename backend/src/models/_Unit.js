const { DataTypes } = require("sequelize");

module.exports = async (sequelize) => {
  return await sequelize.define(
    "_Unit",
    {
      id: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      unit_name: {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
      unit_description: {
        type: DataTypes.STRING(255),
        allowNull: false,
      },
    },
    {
      tableName: "units",
      timestamps: false,
      charset: 'utf8',
      collate: 'utf8_unicode_ci'
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

