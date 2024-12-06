const app = require("./app");
const { Sequelize } = require("sequelize");
const dotenv = require("dotenv");
const sequelize = require('./config/database');

dotenv.config();

const start = async () => {
  // Kiểm tra biến môi trường
  if (
    !process.env.DB_USERNAME ||
    !process.env.DB_PASS ||
    !process.env.DB_IP ||
    !process.env.DB_PORT ||
    !process.env.DB_NAME ||
    !process.env.PORT
  ) {
    console.error("Missing required environment variables. Check your .env file.");
    process.exit(1);
  }

  try {
    await sequelize.sync();
    console.log("=========== Connected to Mariadb ===========");
    console.log(sequelize)
    // Chỉ dùng force: true trong môi trường phát triển
  } catch (err) {
    console.error("Unable to connect to the database:", err);
    process.exit(1); // Thoát ứng dụng nếu không kết nối được cơ sở dữ liệu
  }

  app.listen(process.env.PORT, () => {
    console.log(`Server is running at port ${process.env.PORT ?? 3333} !!!\n`);
  });
};

start();
