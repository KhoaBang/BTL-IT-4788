'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Sample group data
    const shoppings = [
      {
        GID: '123e4567-e89b-12d3-a456-426614174000',  // Generate unique GID
        shopping_id:"c4618765-47bf-4b66-9f64-de834d11f1e5",
        name: 'Bữa noel',
        task_list: JSON.stringify([
          "9daf5d56-9ca6-4ae2-97c8-c5100a90ec1f"
        ]), // Example members
        status: "open",
        createdAt: new Date(),
        updatedAt: new Date(),
      }
    ];

    // Insert data into the groups table
    await queryInterface.bulkInsert('shoppings', shoppings, {});
  },

  down: async (queryInterface, Sequelize) => {
    // If you need to revert the seed (e.g., when rolling back migrations)
    await queryInterface.bulkDelete('shoppings', null, {});
  }
};
