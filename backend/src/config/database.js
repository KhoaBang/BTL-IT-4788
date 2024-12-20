const { Sequelize } = require("sequelize");
const dotenv = require("dotenv");
const { up: userSeederUp } = require("../../seeders/20241201085509-demo-user"); // Corrected import
const { up: groupSeederUp } = require("../../seeders/group.seeder");
const { up: unitSeederUP } = require("../../seeders/unit.seeder");
const { up: shoppingSeederUp} = require("../../seeders/shopping.seeder")
const { up: taskSeederUp} = require("../../seeders/task.seeder")
const { up: mealSeederUp} = require("../../seeders/meal.seeder")


const User_define_fuction = require("../models/_User");
const Group_define_fuction = require("../models/_Group");
const Unit_define_fuction = require("../models/_Unit");
const Shopping_define_function = require("../models/_Shopping")
const Task_define_function = require("../models/_Task")
const Meal_define_function = require("../models/_Meal")

dotenv.config();

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USERNAME,
  process.env.DB_PASS,
  {
    host: process.env.DB_IP,
    port: process.env.DB_PORT,
    dialect: "mariadb",
  }
);

(async () => {
  try {
    const forceSync = process.env.DB_SYNC_FORCE === "true";
     const _User= await User_define_fuction(sequelize);
     const _Group= await Group_define_fuction(sequelize);
     const _Unit= await Unit_define_fuction(sequelize);
     const _Shopping = await Shopping_define_function(sequelize)
     const _Task = await Task_define_function(sequelize)
     const _Meal = await Meal_define_function(sequelize)
    // Sync database (use force only for development or testing environments)
    if (forceSync) {
      await sequelize.sync({ force: "true" }); // This will drop and recreate tables
      console.log("Database tables dropped and recreated.\n");
      const queryInterface = sequelize.getQueryInterface(); // Get queryInterface from sequelize
      await userSeederUp(queryInterface, sequelize); // Pass queryInterface to up function
      await groupSeederUp(queryInterface, sequelize); // Run group seeder as well
      await unitSeederUP(queryInterface, sequelize); // Run unit seeder as well
      await shoppingSeederUp(queryInterface, sequelize);
      await taskSeederUp(queryInterface, sequelize);
      await mealSeederUp(queryInterface, sequelize);
    }else{
      await sequelize.sync({alter: "true"})}

    console.log("Seed data inserted successfully.");
  } catch (error) {
    console.error("Error syncing tables:", error);
  }
})();

module.exports = sequelize;
