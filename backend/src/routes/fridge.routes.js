const { Router } = require('express');
const { requireAppLogin,requireMangager, requireMember  } = require('../middleware/require-auth');
const router = Router();

// fridge có dạng:
/**
[
  {
    "ingredient_name": "Mỳ ý",
    "unit_id": 2,
    "detail": [
      {
        "quantity": 2,
        "createdAt": "2024-12-01" // chỉ có ngày theo format yyyy-mm-dd
      },
      {
        "quantity": 3,
        "createdAt": "2024-12-03"
      }
    ]
  }
]

 */
module.exports = router;
