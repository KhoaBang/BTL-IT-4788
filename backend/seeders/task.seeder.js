'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Sample group data
    const tasks = [
      {
        task_id: "9daf5d56-9ca6-4ae2-97c8-c5100a90ec1f",  
        status:"not completed",
        ingredient_name: "Cà rốt",
        unit_id: 2,
        assigned_to: "cdd7f5fe-00d6-4647-9115-030acbb7fd33",
        createdAt: new Date(),
        updatedAt: new Date(),
      }
    ];

    // Insert data into the groups table
    await queryInterface.bulkInsert('tasks', tasks, {});
  },

  down: async (queryInterface, Sequelize) => {
    // If you need to revert the seed (e.g., when rolling back migrations)
    await queryInterface.bulkDelete('tasks', null, {});
  }
};
