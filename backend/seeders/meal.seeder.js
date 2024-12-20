
'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const meals = [
        {
            meal_id:"54d6d178-8f48-4a3d-8f5c-f25bf43f2372",
            GID: "123e4567-e89b-12d3-a456-426614174000",
            ingredient_list: JSON.stringify(
                [
                    {
                        "ingredient_name": "Cà rốt",
                        "unit_id": 1,
                        "quantity": 1
                    },
                    {
                        "ingredient_name": "Thịt gà",
                        "unit_id": 2,
                        "quantity": 4
                    },

                    {
                        "ingredient_name": "Hành lá",
                        "unit_id": 4,
                        "quantity": 3
                    }
                ]
            ),
            meal_name: "Tất niên",
            consume_date: "2024-12-18",
            createdAt: new Date(),
            updatedAt: new Date(),
        }
    ]
       // Insert data into the groups table
       await queryInterface.bulkInsert('meals', meals, {});
    },
  
    down: async (queryInterface, Sequelize) => {
      // If you need to revert the seed (e.g., when rolling back migrations)
      await queryInterface.bulkDelete('meals', null, {});
    }
  };
  