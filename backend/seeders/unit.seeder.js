'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    const units=[
        {
            id: '1',
            unit_name: 'cái',
            unit_description: "số lượng",
        },
        {
            id: '2',
            unit_name: 'g',
            unit_description: "khối lượng",
        },
        {
            id: '3',
            unit_name: 'kg',
            unit_description: "khối lượng",
        },
        {
            id: '4',
            unit_name: 'l',
            unit_description: "thể tích",
        },
        {
            id: '5',
            unit_name: 'ml',
            unit_description: "thể tích",
        },
    ]
    await queryInterface.bulkInsert('units', units, {});
  },
  down: async (queryInterface, Sequelize) => {
    // If you need to revert the seed (e.g., when rolling back migrations)
    await queryInterface.bulkDelete('units', null, {});
  }
};