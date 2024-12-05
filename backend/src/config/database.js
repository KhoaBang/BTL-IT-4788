const { Sequelize } = require("sequelize");
const dotenv = require("dotenv");
const { up: userSeederUp } = require("../../seeders/20241201085509-demo-user"); // Corrected import
const { up: groupSeederUp } = require("../../seeders/group.seeder");
const { up: unitSeederUP } = require("../../seeders/unit.seeder");
const User_define_fuction = require("../models/_User");
const Group_define_fuction = require("../models/_Group");
const Unit_define_fuction = require("../models/_Unit");

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
    // Sync database (use force only for development or testing environments)
    if (forceSync) {
      await sequelize.sync({ force: "true" }); // This will drop and recreate tables
      console.log("Database tables dropped and recreated.\n");
    }
    const queryInterface = sequelize.getQueryInterface(); // Get queryInterface from sequelize
    await userSeederUp(queryInterface, sequelize); // Pass queryInterface to up function
    await groupSeederUp(queryInterface, sequelize); // Run group seeder as well
    await unitSeederUP(queryInterface, sequelize); // Run unit seeder as well
    console.log("Seed data inserted successfully.");
  } catch (error) {
    console.error("Error syncing tables:", error);
  }
})();

module.exports = sequelize;
