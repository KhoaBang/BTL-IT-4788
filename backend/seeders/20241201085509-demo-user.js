'use strict';
const { v4: uuidv4 } = require('uuid');
const bcrypt = require('bcrypt'); // If you want to hash the password

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Sample user data
    const users = [
      {
        UUID: 'cdd7f5fe-00d6-4647-9115-030acbb7fd33',
        username: 'NgocMinh',
        dob: '1990-01-01',
        email: 'NgocMinh@gmail.com',
        password: bcrypt.hashSync('1234567890', 10), // Hash the password for storage
        phone: '0901729618',
        role: 'User',
        refresh_token: 'EMPTY',
        status: 'Active',
        tag_list: JSON.stringify([]), // Corrected empty JSON array
        personal_ingredient_list: JSON.stringify([]), // Corrected empty JSON array
        member_of: JSON.stringify([{'GID':'123e4567-e89b-12d3-a456-426614174000','group_name':'Group A'}]), // Corrected empty JSON array
        manager_of: JSON.stringify([{'GID':'bfebd365-aed2-436f-9664-c6faa9c4820a','group_name':'Group B'}]), // Corrected empty JSON array
      },
      {
        UUID: 'ae83d2e2-ecee-4251-990d-696b00dea251',
        username: 'koba',
        dob: '1985-05-15',
        email: 'koba@gmail.com',
        password: bcrypt.hashSync('1234567890', 10),
        phone: '0901729617',
        role: 'User',
        refresh_token: 'EMPTY',
        status: 'Active',
        tag_list: JSON.stringify([]), // Corrected empty JSON array
        personal_ingredient_list: JSON.stringify([]), // Corrected empty JSON array
        member_of: JSON.stringify([]), // Corrected empty JSON array
        manager_of: JSON.stringify([{'GID':'123e4567-e89b-12d3-a456-426614174000','group_name':'Group A'}]), 
      },
      {
        UUID: 'c7f3b1fc-6b5d-4bb9-aa8d-94f239f327cb',
        username: 'AnhKhoi',
        dob: '1985-05-15',
        email: 'AnhKhoi@gmail.com',
        password: bcrypt.hashSync('1234567890', 10),
        phone: '0901729619',
        role: 'User',
        refresh_token: 'EMPTY',
        status: 'Active',
        tag_list: JSON.stringify([]), // Corrected empty JSON array
        personal_ingredient_list: JSON.stringify([]), // Corrected empty JSON array
        member_of: JSON.stringify([{'GID':'123e4567-e89b-12d3-a456-426614174000','group_name':'Group A'}]), // Corrected empty JSON array
        manager_of: JSON.stringify([]), // Corrected empty JSON array
      },
      {
        UUID: 'b87fbe35-cfd3-4450-9b2c-cef151d6f5d5',
        username: 'NhatLinh',
        dob: '1985-05-15',
        email: 'NhatLinh@gmail.com',
        password: bcrypt.hashSync('1234567890', 10),
        phone: '0901729620',
        role: 'User',
        refresh_token: 'EMPTY',
        status: 'Active',
        tag_list: JSON.stringify([]), // Corrected empty JSON array
        personal_ingredient_list: JSON.stringify([]), // Corrected empty JSON array
        member_of: JSON.stringify([{'GID':'bfebd365-aed2-436f-9664-c6faa9c4820a','group_name':'Group B'}]), // Corrected empty JSON array
        manager_of: JSON.stringify([]), // Corrected empty JSON array
      },
      {
        UUID: '973e79a6-d04e-4cf2-a807-fd5de7f3ab0d',
        username: 'HaiNam',
        dob: '1985-05-15',
        email: 'HaiNam@gmail.com',
        password: bcrypt.hashSync('1234567890', 10),
        phone: '0901729621',
        role: 'User',
        refresh_token: 'EMPTY',
        status: 'Active',
        tag_list: JSON.stringify(["rau","thịt","hải sản","hương liệu","nguyên liệu nấu phở","nguyên liệu làm bánh","gia vị"]), // Corrected empty JSON array
        personal_ingredient_list: JSON.stringify(
            [
                {
                    "ingredient_name": "Cà rốt",
                    "unit_id": 1,
                    "tags": [
                        {"tag_name": "rau"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "Thịt gà",
                    "unit_id": 2,
                    "tags": [
                        {"tag_name": "thịt"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "Tôm",
                    "unit_id": 3,
                    "tags": [
                        {"tag_name": "hải sản"},
                        {"tag_name": "nguyên liệu làm bánh"}
                    ]
                },
                {
                    "ingredient_name": "Hành lá",
                    "unit_id": 4,
                    "tags": [
                        {"tag_name": "rau"},
                        {"tag_name": "hương liệu"}
                    ]
                },
                {
                    "ingredient_name": "Muối",
                    "unit_id": 5,
                    "tags": [
                        {"tag_name": "gia vị"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "Bột mì",
                    "unit_id": 2,
                    "tags": [
                        {"tag_name": "nguyên liệu làm bánh"},
                        {"tag_name": "gia vị"}
                    ]
                }
            ]

        
        ), // Corrected empty JSON array
        member_of: JSON.stringify([{'GID':'bfebd365-aed2-436f-9664-c6faa9c4820a','group_name':'Group B'}]), // Corrected empty JSON array
        manager_of: JSON.stringify([]), // Corrected empty JSON array
      },
    ];

    // Insert data into the users table
    await queryInterface.bulkInsert('users', users, {});
  },

  down: async (queryInterface, Sequelize) => {
    // If you need to revert the seed (e.g., when rolling back migrations)
    await queryInterface.bulkDelete('users', null, {});
  }
};
