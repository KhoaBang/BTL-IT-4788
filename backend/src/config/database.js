const { Sequelize } = require('sequelize');
const dotenv = require('dotenv');
const { up: userSeederUp } = require('../../seeders/20241201085509-demo-user');  // Corrected import
const { up: groupSeederUp } = require('../../seeders/group.seeder');

dotenv.config();

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USERNAME,
  process.env.DB_PASS,
  {
    host: process.env.DB_IP,
    port: process.env.DB_PORT,
    dialect: 'mariadb',
    logging: process.env.NODE_ENV === 'production' ? false : console.log, // Enable logging only in development
  }
);

(async () => {
  try {
    const forceSync = process.env.DB_SYNC_FORCE === 'true';
    
    // Sync database (use force only for development or testing environments)
    if (forceSync) {
      await sequelize.sync({ force: forceSync }); // This will drop and recreate tables
      console.log('Database tables dropped and recreated.');
      
      const queryInterface = sequelize.getQueryInterface();  // Get queryInterface from sequelize
      await userSeederUp(queryInterface, sequelize);  // Pass queryInterface to up function
      await groupSeederUp(queryInterface, sequelize);  // Run group seeder as well
      console.log('Seed data inserted successfully.');
    } else {
      // Alter tables if schema changes but do not drop them
      await sequelize.sync({ alter: true });
      console.log('Database tables synchronized successfully.');
    }
    
  } catch (error) {
    console.error('Error syncing tables:', error);
  }
})();

module.exports = sequelize;
