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
        recipe_list: JSON.stringify([])
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
        recipe_list: JSON.stringify([])
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
        recipe_list: JSON.stringify([])
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
        tag_list: JSON.stringify(["rau","thịt","hải sản","hương liệu","nguyên liệu nấu phở","nguyên liệu làm bánh","gia vị"]), // Corrected empty JSON array
        personal_ingredient_list: JSON.stringify(
            [
                {
                    "ingredient_name": "cà rốt",
                    "unit_id": 1,
                    "tags": [
                        {"tag_name": "rau"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "thịt gà",
                    "unit_id": 2,
                    "tags": [
                        {"tag_name": "thịt"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "tôm",
                    "unit_id": 3,
                    "tags": [
                        {"tag_name": "hải sản"},
                        {"tag_name": "nguyên liệu làm bánh"}
                    ]
                },
                {
                    "ingredient_name": "hành lá",
                    "unit_id": 4,
                    "tags": [
                        {"tag_name": "rau"},
                        {"tag_name": "hương liệu"}
                    ]
                },
                {
                    "ingredient_name": "muối",
                    "unit_id": 5,
                    "tags": [
                        {"tag_name": "gia vị"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "bột mì",
                    "unit_id": 2,
                    "tags": [
                        {"tag_name": "nguyên liệu làm bánh"},
                        {"tag_name": "gia vị"}
                    ]
                }
            ]
        ),
        member_of: JSON.stringify([{'GID':'bfebd365-aed2-436f-9664-c6faa9c4820a','group_name':'Group B'}]), // Corrected empty JSON array
        manager_of: JSON.stringify([]), // Corrected empty JSON array
        recipe_list: JSON.stringify([])
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
                    "ingredient_name": "cà rốt",
                    "unit_id": 1,
                    "tags": [
                        {"tag_name": "rau"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "thịt gà",
                    "unit_id": 2,
                    "tags": [
                        {"tag_name": "thịt"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "tôm",
                    "unit_id": 3,
                    "tags": [
                        {"tag_name": "hải sản"},
                        {"tag_name": "nguyên liệu làm bánh"}
                    ]
                },
                {
                    "ingredient_name": "hành lá",
                    "unit_id": 4,
                    "tags": [
                        {"tag_name": "rau"},
                        {"tag_name": "hương liệu"}
                    ]
                },
                {
                    "ingredient_name": "muối",
                    "unit_id": 5,
                    "tags": [
                        {"tag_name": "gia vị"},
                        {"tag_name": "nguyên liệu nấu phở"}
                    ]
                },
                {
                    "ingredient_name": "bột mì",
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
        recipe_list: JSON.stringify(
          {
            "name": "Cơm Chiên Hải Sản",
            "description": "Món cơm chiên thơm ngon kết hợp giữa tôm, mực và rau.",
            "prep_time_minutes": 15,
            "cook_time_minutes": 20,
            "servings": 4,
            "ingredients": [
              {
                "ingredient_name": "cơm",
                "quantity": 500,
                "unit_id": 2
              },
              {
                "ingredient_name": "tôm",
                "quantity": 200,
                "unit_id": 2
              },
              {
                "ingredient_name": "mực",
                "quantity": 150,
                "unit_id": 2
              },
              {
                "ingredient_name": "đậu",
                "quantity": 100,
                "unit_id": 2
              },
              {
                "ingredient_name": "cà rốt",
                "quantity": 1,
                "unit_id": 1
              },
              {
                "ingredient_name": "trứng",
                "quantity": 2,
                "unit_id": 1
              },
              {
                "ingredient_name": "hành",
                "quantity": 50,
                "unit_id": 2
              },
              {
                "ingredient_name": "nước tương",
                "quantity": 30,
                "unit_id": 2
              }
            ],
            "steps": [
              "Luộc tôm và mực, cắt nhỏ.",
              "Phi thơm hành, thêm tôm và mực vào xào.",
              "Thêm cà rốt, đậu, và cơm vào xào đều.",
              "Đánh trứng, đổ vào chảo và đảo đều.",
              "Nêm nước tương, rắc hành, và phục vụ nóng."
            ],
            "notes": "Có thể thêm ớt nếu thích ăn cay."
          },
          {
            "name": "Bánh Xèo",
            "description": "Món bánh truyền thống Việt Nam giòn rụm với nhân thịt, tôm và rau.",
            "prep_time_minutes": 20,
            "cook_time_minutes": 40,
            "servings": 4,
            "ingredients": [
              {
                "ingredient_name": "bột",
                "quantity": 400,
                "unit_id": 2
              },
              {
                "ingredient_name": "nước",
                "quantity": 200,
                "unit_id": 2
              },
              {
                "ingredient_name": "thịt",
                "quantity": 200,
                "unit_id": 2
              },
              {
                "ingredient_name": "tôm",
                "quantity": 150,
                "unit_id": 2
              },
              {
                "ingredient_name": "rau",
                "quantity": 200,
                "unit_id": 2
              },
              {
                "ingredient_name": "hành",
                "quantity": 50,
                "unit_id": 2
              }
            ],
            "steps": [
              "Trộn bột với nước, thêm hành.",
              "Chiên thịt và tôm.",
              "Đổ bột vào chảo, xoay đều.",
              "Thêm thịt, tôm và rau, gập đôi bánh.",
              "Chiên giòn và phục vụ với rau và nước chấm."
            ],
            "notes": "Dùng chảo chống dính để bánh giòn lâu hơn."
          }
          
        )
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
