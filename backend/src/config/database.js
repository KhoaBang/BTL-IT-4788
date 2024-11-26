const { Sequelize } = require('sequelize');
const dotenv = require('dotenv');

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
    const isProduction = process.env.NODE_ENV === 'production';

    // Sync models with database
    await sequelize.sync({ force: !isProduction }); // Force only in non-production
    console.log('All tables have been synchronized successfully!');
  } catch (error) {
    console.error('Error syncing tables:', error);
  }
})();

module.exports = sequelize;
