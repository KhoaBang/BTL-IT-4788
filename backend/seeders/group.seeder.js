'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Sample group data
    const groups = [
      {
        GID: '123e4567-e89b-12d3-a456-426614174000',  // Generate unique GID
        group_name: 'Group A',
        manager_id: 'ae83d2e2-ecee-4251-990d-696b00dea251', // Use a valid UUID for manager
        blacklist: JSON.stringify([]), // Empty blacklist
        member_ids: JSON.stringify([
          { UUID: 'cdd7f5fe-00d6-4647-9115-030acbb7fd33', email: 'NgocMinh@gmail.com' },
          { UUID: 'c7f3b1fc-6b5d-4bb9-aa8d-94f239f327cb', email: 'AnhKhoi@gmail.com' }
        ]), // Example members
        group_code: 'A1B2C3D', // Sample 7-character invite code
        fridge: JSON.stringify(
          [
            {
              "ingredient_name": "Cà rốt",
              "unit_id": 1,
              "detail": [
                {
                  "quantity": 2,
                  "createdAt": "2024-12-01"
                },
                {
                  "quantity": 5,
                  "createdAt": "2024-12-03"
                }
              ]
            },
            {
              "ingredient_name": "Thịt gà",
              "unit_id": 2,
              "detail": [
                {
                  "quantity": 1,
                  "createdAt": "2024-12-02"
                },
                {
                  "quantity": 3,
                  "createdAt": "2024-12-04"
                }
              ]
            }]
        ),
        createdAt: new Date(),
        updatedAt: new Date(),
      },
      {
        GID: 'bfebd365-aed2-436f-9664-c6faa9c4820a',
        group_name: 'Group B',
        manager_id: '973e79a6-d04e-4cf2-a807-fd5de7f3ab0d',
        blacklist: JSON.stringify([{ UUID: 'ae83d2e2-ecee-4251-990d-696b00dea251' }]), // Example blacklist with 1 UUID
        member_ids: JSON.stringify([
          { UUID: 'b87fbe35-cfd3-4450-9b2c-cef151d6f5d5', email: 'NhatLinh@gmail.com' },
        ]),
        group_code: 'E4F5G6H',
        fridge: JSON.stringify(
          [
            {
              "ingredient_name": "Cà rốt",
              "unit_id": 1,
              "detail": [
                {
                  "quantity": 2,
                  "createdAt": "2024-12-01"
                },
                {
                  "quantity": 5,
                  "createdAt": "2024-12-03"
                }
              ]
            },
            {
              "ingredient_name": "Thịt gà",
              "unit_id": 2,
              "detail": [
                {
                  "quantity": 1,
                  "createdAt": "2024-12-02"
                },
                {
                  "quantity": 3,
                  "createdAt": "2024-12-04"
                }
              ]
            }]
        ),
        createdAt: new Date(),
        updatedAt: new Date(),
      },
    ];

    // Insert data into the groups table
    await queryInterface.bulkInsert('groups', groups, {});
  },

  down: async (queryInterface, Sequelize) => {
    // If you need to revert the seed (e.g., when rolling back migrations)
    await queryInterface.bulkDelete('groups', null, {});
  }
};
